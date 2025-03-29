extends Node2D
class_name Cheshire

@export var deck: Deck
@export var anim: AnimationPlayer
@export var sprite: AnimatedSprite2D
@export var dealt_positions: Array[Marker2D]

var selected_cards: Array[Card]

signal cheshire_closed
signal five_selected

func _ready():
	open()

func open() -> void:
	sprite.visible = true
	anim.play("OpenMouth")
	splay_cards()

func close():
	anim.play("CloseMouth")
	await anim.animation_finished
	cheshire_closed.emit()
	#visible = false
	queue_free()

func splay_cards():
	for i in range(0, len(deck.deck)):
		var tween = create_tween()
		tween.tween_property(deck.deck[i], "global_position", dealt_positions[i].global_position, 0.2)
		deck.deck[i].card_clicked.connect(on_card_clicked)
		
func on_card_clicked(card):
	if len(selected_cards) == 5:
		return
		
	if card not in selected_cards:
		selected_cards.append(card)
		card.modulate = Color(card.modulate.r, card.modulate.g, card.modulate.b, 0.6)
	else:
		var index = -1
		for i in range(0, len(selected_cards)):
			if str(selected_cards[i]) == str(card):
				index = i
				break
		
		selected_cards.pop_at(index)
		card.modulate = Color(card.modulate.r, card.modulate.g, card.modulate.b, 1)
		
	if len(selected_cards) == 5:
		five_selected.emit()
		
	
