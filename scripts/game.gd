extends Node2D

@export var deck: Node2D
var dealt_card = []

func _ready() -> void:
	deal(10)
	print("dealt cards: \n")
	print(dealt_card)
	
func deal(deal_size: int):
	for i in range(0, deal_size):
		dealt_card.append(deck.deck[i])
