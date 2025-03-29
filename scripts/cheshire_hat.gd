extends Node2D

@export var deck: Deck
@export var anim: AnimationPlayer
@export var dealt_positions: Array[Marker2D]

func _ready() -> void:
	anim.play("OpenMouth")
	await anim.animation_finished
	make_invisible()
	deal()

func make_invisible():
	for card in deck.deck:
		card.visible = false

func deal():
	var tween_duration = 0.2
	for i in range(0, deck.deck_size):
		deck.deck[i].face_up = true
		deck.deck[i].visible = true
		var tween = create_tween()
		tween.tween_property(deck.deck[i],"global_position",dealt_positions[i].global_position,tween_duration)
		await start_timer(tween_duration)
	

func close():
	anim.play("CloseMouth")
	await anim.animation_finished

func start_timer(wait_time: float):
	var timer = Timer.new() 
	timer.wait_time = wait_time
	timer.one_shot = true
	timer.autostart = false
	add_child(timer)
	timer.start()
	await timer.timeout
	timer.queue_free()
