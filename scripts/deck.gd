extends Node2D

var card_scene = preload("res://scenes/card.tscn")

var deck: Array = []

@export var is_default: bool = true
@export var deck_size: int = 52

func _ready():
	initialize_deck()
	if is_default:
		deck.shuffle()

func initialize_deck():
	if is_default:
		for i in range(0, Card.RANK.values().size()):
			for j in range(0, Card.SUIT.values().size()):
				var card = card_scene.instantiate()
				card.rank = i
				card.suit = j
				card.type = card.TYPE.NORMAL
				card.face_up = false
				card.update_card()
				deck.append(card)
				add_child(card)
	else:
		for i in range(1, deck_size):
			var card = card_scene.instantiate()
			deck.append(card)
			add_child(card)

func shuffle_deck():
	deck.shuffle()
