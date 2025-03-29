extends Node2D
class_name Cheshire

@export var deck: Deck
@export var anim: AnimationPlayer
@export var sprite: AnimatedSprite2D
@export var dealt_positions: Array[Marker2D]

func _ready():
	make_invisible()

func open() -> void:
	sprite.visible = true
	anim.play("OpenMouth")
	await anim.animation_finished

func make_invisible():
	sprite.visible = false
	for card in deck.deck:
		card.visible = false

func close():
	anim.play("CloseMouth")
	await anim.animation_finished
