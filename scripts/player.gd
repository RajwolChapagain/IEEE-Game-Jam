extends Node2D
class_name Player

@export var initial_hp: int = 5

var hp: int = initial_hp
var hand: Array[Card] = []
@export var relics: Array[Relic.relic_type]

signal entity_damaged
signal entity_died

func pick(card: Card) -> void:
	hand.append(card)
	order_hand()

func shuffle_hand():
	for card in hand:
		card.face_up = false
		card.update_card()
	hand.shuffle()
	order_hand()

func order_hand():
	for i in range(0, hand.size()):
		var tween = create_tween()
		tween.tween_property(hand[i],"global_position:y",global_position.y,0.1)
		tween.parallel()
		tween.tween_property(hand[i],"global_position:x",global_position.x + i * 75,0.1)

func clear():
	hand.clear()

func take_damage(damage):
	hp -= damage
	entity_damaged.emit()
	if hp <= 0:
		entity_died.emit()
