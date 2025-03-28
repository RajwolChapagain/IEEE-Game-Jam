extends Node2D

var hp: int = 5
var hand: Array[Card] = []

func pick(card: Card) -> void:
	card.position.y = position.y 
	card.position.x = position.x + len(hand) * 75
	hand.append(card)
