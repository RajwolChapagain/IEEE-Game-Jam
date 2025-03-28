extends Node

var hp: int = 5
var hand: Array[Card] = []

func pick(card: Card) -> void:
	hand.append(card)
