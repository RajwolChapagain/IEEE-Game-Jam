extends Node2D

@export var deck: Node2D
@export var dealt_positions: Array[Marker2D]

var dealt_card = []

func _ready() -> void:
	deal(10)
	print("dealt cards: \n")
	print(dealt_card)
	
func deal(deal_size: int):
	for i in range(0, deal_size):
		dealt_card.append(deck.deck[i])
		dealt_card[i].global_position = dealt_positions[i].global_position
