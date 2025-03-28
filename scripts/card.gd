extends Area2D

enum RANK {TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING, ACE}
enum SUIT {SPADE, CLUB, DIAMOND, HEART}
enum TYPE {NORMAL, FIRE, WATER, NATURE}

var rank: int
var suit: int
var type: int
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
