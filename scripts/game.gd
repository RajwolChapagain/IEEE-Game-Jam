extends Node2D

@export var deck: Node2D
@export var dealt_positions: Array[Marker2D]

var dealt_card = []

func _ready():
	deal(10)
	for card in dealt_card:
		card.card_clicked.connect(_on_card_clicked)
	
func deal(deal_size: int):
	for i in range(0, deal_size):
		dealt_card.append(deck.deck[i])
		dealt_card[i].face_up = true
		dealt_card[i].global_position = dealt_positions[i].global_position
		dealt_card[i].update_card()

func _on_card_clicked(card: Card):
	print(card.get_pretty_string())
	card.global_position.y += 50
	card.update_card()
