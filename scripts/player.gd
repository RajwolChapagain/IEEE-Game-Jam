extends Node2D
class_name Player

var hp: int = 5
var hand: Array[Card] = []

func pick(card: Card) -> void:
	card.global_position.y = global_position.y 
	card.global_position.x = global_position.x + len(hand) * 75
	hand.append(card)
