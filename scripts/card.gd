extends Area2D
class_name Card

enum RANK {TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING, ACE}
enum SUIT {HEART, CLUB, DIAMOND, SPADE}
enum TYPE {NORMAL, TREE, WATER, FIRE}

const RANK_STRINGS = ["Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Jack", "Queen", "King", "Ace"]
const SUIT_STRINGS = ["Hearts", "Clubs", "Diamonds", "Spades"]
const TYPE_STRINGS = ["Normal", "Tree", "Water", "Fire"]

var rank: int = randi_range(0, RANK.values().size()-1)
var suit: int = randi_range(0, SUIT.values().size()-1)
var type: int = randi_range(0, TYPE.values().size()-1)
var face_up: bool = true
var hovered: bool = true
var applied_effects = []

@export var Rank_Sprite: AnimatedSprite2D
@export var Suit_Sprite: AnimatedSprite2D
@export var Type_Sprite: AnimatedSprite2D
@export var Flip_Sprite: Sprite2D
@export var Effects_Sprite_Array: Array[AnimatedSprite2D]

signal card_clicked(card)

func _ready() -> void:
	update_card()

func update_card():
	Suit_Sprite.frame = suit
	Type_Sprite.frame = type
	
	if suit == SUIT.SPADE || suit == SUIT.CLUB:
		Rank_Sprite.frame = rank
	else:
		Rank_Sprite.frame = rank + 13
	if !face_up:
		Flip_Sprite.visible = true
		hide_effects()
	else:
		Flip_Sprite.visible = false
		display_effects()

# Emit signal when clicked
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("pick"):
		card_clicked.emit(self)
		
# Returns a readable string representing the card
func get_pretty_string() -> String:
	return str(TYPE_STRINGS[type]) + " " + str(RANK_STRINGS[rank]) + " of " + str(SUIT_STRINGS[suit])
	
func get_comparison_val() -> int:
	var comp_val = rank
	for effect in applied_effects:
		comp_val = Relic.apply_relic(comp_val, effect)
	return comp_val

func display_effects() -> void:
	for effect in applied_effects:
		var anim_sprite = Effects_Sprite_Array.pick_random()
		anim_sprite.visible = true
		anim_sprite.frame = effect

func hide_effects() -> void:
	for animated_sprite in Effects_Sprite_Array:
		animated_sprite.visible = false
	
