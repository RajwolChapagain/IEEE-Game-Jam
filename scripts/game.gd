extends Node2D

@export var deck: Node2D
@export var player: Player
@export var enemy: Player
@export var dealt_positions: Array[Marker2D]

var dealt_card: Array[Card] = []
var player_turn: bool = false
var deal_size: int = 10

func _ready():
	deal()
	for card in dealt_card:
		card.card_clicked.connect(_on_card_clicked)
	enemy_pick()
	
func deal():
	for i in range(0, deal_size):
		dealt_card.append(deck.deck[i])
		dealt_card[i].face_up = true
		dealt_card[i].global_position = dealt_positions[i].global_position
		dealt_card[i].update_card()

func enemy_pick():
	if dealt_card.size() > 0:
		var index: int = randi_range(0, dealt_card.size()-1)
		enemy.pick(dealt_card[index])
		dealt_card.pop_at(index)
		player_turn = not player_turn
	else:
		start_battle()

func start_battle():
	var timer = Timer.new()
	timer.wait_time = 3
	timer.one_shot = false
	timer.autostart = false
	add_child(timer)
	player.shuffle_hand()
	player.order_hand()
	enemy.shuffle_hand()
	enemy.order_hand()
	for i in range(0, int(deal_size/2)):
		timer.start()
		player.hand[i].face_up = true
		player.hand[i].update_card()
		enemy.hand[i].face_up = true
		enemy.hand[i].update_card()
		var cmp = Calculator.compare(player.hand[i], enemy.hand[i])
		if cmp > 0:
			enemy.hp-=1
			print(player.hand[i].get_pretty_string(), "  wins")
		elif cmp < 0:
			player.hp-=1
			print(enemy.hand[i].get_pretty_string(), "  wins")
		else:
			print("draw")
			pass
			
		await timer.timeout

func _on_card_clicked(card: Card):
	if player_turn:
		player.pick(card)
		remove_from_dealt(card)
		player_turn = not player_turn
		enemy_pick()

func remove_from_dealt(card):
	for i in range(0, dealt_card.size()):
		if str(dealt_card[i]) == str(card):
			dealt_card.pop_at(i)
			return
			
