extends Node2D

@export var deck: Deck
@export var player: Player
@export var enemy: Player
@export var dealt_positions: Array[Marker2D]

var dealt_card: Array[Card] = []
var player_turn: bool = false
var deal_size: int = 10

func _ready():
	start_game()

func start_game():
	deal()
	enemy_turn()

func deal():
	for i in range(0, deal_size):
		dealt_card.append(deck.deck[i])
		dealt_card[i].card_clicked.connect(_on_card_clicked)
		dealt_card[i].face_up = true
		dealt_card[i].global_position = dealt_positions[i].global_position
		dealt_card[i].update_card()

func enemy_turn():
	if dealt_card.size() > 0:
		var index: int = randi_range(0, dealt_card.size()-1)
		dealt_card[index].card_clicked.disconnect(_on_card_clicked)
		enemy.pick(dealt_card[index])
		dealt_card.pop_at(index)
		player_turn = not player_turn
	else:
		var battle_progress = await start_battle()
		if battle_progress == 0:
			continue_game()

func continue_game():
	clear_game()
	start_game()

func start_battle() -> int:
	var timer = Timer.new() 
	timer.wait_time = 1
	timer.one_shot = false
	timer.autostart = false
	add_child(timer)
	
	player.shuffle_hand()
	player.order_hand()
	enemy.shuffle_hand()
	enemy.order_hand()
	
	for i in range(0, int(deal_size/2)):
		timer.start()
		await timer.timeout
		
		player.hand[i].face_up = true
		player.hand[i].update_card()
		enemy.hand[i].face_up = true
		enemy.hand[i].update_card()
		
		var cmp = Calculator.compare(player.hand[i], enemy.hand[i])
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
			print("PLAYER DIED")
			timer.queue_free()
			return -1
		elif enemy.hp <= 0:
			print("ENEMY DIED")
			timer.queue_free()
			return 1
	print("NEXT ROUND")
	timer.queue_free()
	return 0

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
			
