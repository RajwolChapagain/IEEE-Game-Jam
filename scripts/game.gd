extends Node2D

@export var deck: Node2D
@export var dealt_positions: Array[Marker2D]

var dealt_card: Array[Card] = []
var player_hand: Array[Card]= []
var enemy_hand: Array[Card] = []
var player_turn : bool = false

func _ready():
	deal(10)
	for card in dealt_card:
		card.card_clicked.connect(_on_card_clicked)
	enemy_pick()
	
func deal(deal_size: int):
	for i in range(0, deal_size):
		dealt_card.append(deck.deck[i])
		dealt_card[i].face_up = true
		dealt_card[i].global_position = dealt_positions[i].global_position
		dealt_card[i].update_card()

func enemy_pick():
	if dealt_card.size() > 0:
		var index: int = randi_range(0, dealt_card.size()-1)
		enemy_hand.append(dealt_card[index])
		dealt_card[index].global_position.y -= 50
		dealt_card.pop_at(index)
		player_turn = not player_turn
	
func _on_card_clicked(card: Card):
	if player_turn:
		print(card.get_pretty_string())
		card.global_position.y += 50
		card.update_card()
		player_hand.append(card)
		remove_from_dealt(card)
		player_turn = not player_turn
		enemy_pick()

func remove_from_dealt(card):
	for i in range(0, dealt_card.size()):
		if str(dealt_card[i]) == str(card):
			dealt_card.pop_at(i)
			return
			
