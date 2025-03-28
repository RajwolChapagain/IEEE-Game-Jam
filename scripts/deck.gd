extends Node2D

var card_scene = preload("res://scenes/card.tscn")

var deck: Array = []

@export var is_default: bool = true
@export var deck_size: int = 52

func _ready():
	initialize_deck()
	print(deck)

func initialize_deck():
	var card = card_scene.instantiate()
	if is_default:
		for i in range(0, card.RANK.values().size()):
			for j in range(0, card.SUIT.values().size()):
				card = card_scene.instantiate()
				card.rank = i
				card.suit = j
				card.type = card.TYPE.NORMAL
				deck.append(card)
				add_child(card)
	else:
		for i in range(1, deck_size):
			card = card_scene.instantiate()
			deck.append(card)
			add_child(card)

func shuffle_deck():
	deck.shuffle()
