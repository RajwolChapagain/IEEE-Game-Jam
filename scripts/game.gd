extends Node2D

@export var deck: Deck
@export var player: Player
@export var enemy: Player
@export var dealt_positions: Array[Marker2D]

enum BATTLE {LOSS, WIN, CONTINUE}

var dealt_card: Array[Card] = []
var player_turn: bool = false
var deal_size: int = 10
var battle_ended: bool = false

func _ready():
	start_game()

func start_game():
	await deal()
	enemy_turn()

func deal():
	var tween_duration = 0.2
	for i in range(0, deal_size):
		dealt_card.append(deck.deck[i])
		dealt_card[i].card_clicked.connect(_on_card_clicked)
		dealt_card[i].face_up = true
		var tween = create_tween()
		tween.tween_property(dealt_card[i],"global_position",dealt_positions[i].global_position,tween_duration)
		dealt_card[i].update_card()
	await start_timer(tween_duration)

func enemy_turn():
	if dealt_card.size() > 0:
		var index: int = randi_range(0, dealt_card.size()-1)
		dealt_card[index].card_clicked.disconnect(_on_card_clicked)
		enemy.pick(dealt_card[index])
		dealt_card.pop_at(index)
		player_turn = not player_turn
	else:
		start_battle()

func continue_game():
	clear_game()
	start_game()

func start_battle():
	player.shuffle_hand()
	enemy.shuffle_hand()

	do_battle()
	
func do_battle() -> void:
	var hand_size: int = deal_size / 2
	
	for i in range(0, hand_size):
		await do_round(player.hand[i], enemy.hand[i])
		if battle_ended:
			return
	
	continue_game()

func do_round(player_card: Card, enemy_card: Card) -> void:
	await start_timer(0.8)
	
	flip_card_up(player_card)
	flip_card_up(enemy_card)
	
	compare_cards_and_do_damage(player_card, enemy_card)
	
func compare_cards_and_do_damage(player_card, enemy_card):
	var cmp = Calculator.compare(player_card, enemy_card)
	
	if cmp == 1:
		damage_entity(enemy)
	elif cmp == -1:
		damage_entity(player)
	else:
		# Draw
		pass

func damage_entity(entity: Player) -> void:
	entity.take_damage(1)

func flip_card_up(card: Card) -> void:
	card.face_up = true
	card.update_card()

func flip_card_down(card: Card) -> void:
	card.face_up = false
	card.update_card()
	
func start_timer(wait_time: float):
	var timer = Timer.new() 
	timer.wait_time = wait_time
	timer.one_shot = true
	timer.autostart = false
	add_child(timer)
	timer.start()
	await timer.timeout
	timer.queue_free()

func clear_game():
	player.clear()
	enemy.clear()
	dealt_card.clear()
	deck.clear()
	deck.shuffle_deck()

func _on_card_clicked(card: Card):
	if player_turn:
		card.card_clicked.disconnect(_on_card_clicked)
		player.pick(card)
		remove_from_dealt(card)
		player_turn = not player_turn
		enemy_turn()

func remove_from_dealt(card):
	for i in range(0, dealt_card.size()):
		if str(dealt_card[i]) == str(card):
			dealt_card.pop_at(i)
			return

func _on_player_entity_died() -> void:
	end_battle(false)
	print("Player lost!")

func _on_enemy_entity_died() -> void:
	end_battle(true)
	print("Player won!")
	
func end_battle(player_won: bool) -> void:
	battle_ended = true
	return_cards()

func return_cards():
	# Flips the hands down and empties the hands arrays
	player.hand.all(flip_card_down)
	player.hand.clear() 
	enemy.hand.all(flip_card_down)
	enemy.hand.clear()
	
	# Returns all cards to the deck's position
	deck.clear() 
	
