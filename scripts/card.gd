extends Area2D

enum RANK {TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING, ACE}
enum SUIT {SPADE, CLUB, DIAMOND, HEART}
enum TYPE {NORMAL, FIRE, WATER, NATURE}

var rank: int = randi_range(0, RANK.values().size()-1)
var suit: int = randi_range(0, SUIT.values().size()-1)
var type: int = randi_range(0, TYPE.values().size()-1)
var face_up: bool = true

@export var Rank_Sprite: AnimatedSprite2D
@export var Suit_Sprite: AnimatedSprite2D
@export var Type_Sprite: AnimatedSprite2D

func _ready() -> void:
	update_card()
	pass

func update_card():
	Rank_Sprite.frame = rank
	Suit_Sprite.frame = suit
	Type_Sprite.frame = type
