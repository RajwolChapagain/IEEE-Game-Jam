extends Node2D

@export var deck: Deck
@export var player: Player
@export var enemy: Player
@export var dealt_positions: Array[Marker2D]

enum BATTLE {LOSS, WIN, CONTINUE}

var dealt_card: Array[Card] = []
var player_turn: bool = false
var deal_size: int = 10

signal done_dealing

func _ready():
	done_dealing.connect(on_done_dealing)
	start_game()

func start_game():
	deal()

func on_done_dealing():
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
	await round_timer(tween_duration)
	done_dealing.emit()

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
	player.order_hand()
	enemy.shuffle_hand()
	enemy.order_hand()
	
	for i in range(0, int(deal_size/2)):
		var battle_result = await battle_round(player.hand[i], enemy.hand[i])
		if battle_result == BATTLE.WIN:
			print("PLAYER WINS")
			return BATTLE.WIN
		elif battle_result == BATTLE.LOSS:
			print("PLAYER DIED")
			return BATTLE.LOSS
		else:
			pass
	
	continue_game()

func battle_round(player_card: Card, enemy_card: Card) -> int:
	await round_timer(1)
	
	player_card.face_up = true
	player_card.update_card()
	enemy_card.face_up = true
	enemy_card.update_card()
	
	var cmp = Calculator.compare(player_card, enemy_card)
	if cmp > 0:
		enemy.hp-=1
		print("player wins round")
	elif cmp < 0:
		player.hp-=1
		print("enemy wins round")
	else:
		print("draw round")
		pass
		
	if player.hp <= 0:
		return BATTLE.LOSS
	elif enemy.hp <= 0:
		return BATTLE.WIN
	else:
		return BATTLE.CONTINUE

func round_timer(wait_time: float):
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
			
