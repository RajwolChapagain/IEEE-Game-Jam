extends Node2D
class_name Player

@export var initial_hp: int = 5

var hp: int = initial_hp
var hand: Array[Card] = []

func pick(card: Card) -> void:
	hand.append(card)
	order_hand()

func shuffle_hand():
	for card in hand:
		card.face_up = false
		card.update_card()
	hand.shuffle()

func order_hand():
	for i in range(0, hand.size()):
		hand[i].global_position.y = global_position.y 
		hand[i].global_position.x = global_position.x + i * 75

func clear():
	hand.clear()
