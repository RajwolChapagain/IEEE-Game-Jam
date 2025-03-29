extends Control

signal relic_picked(relic_type)

func initialize(relic1, relic2):
	$HBoxContainer/Button/AnimatedSprite2D.frame = relic1
	$HBoxContainer/Button2/AnimatedSprite2D2.frame = relic2

func _on_button_button_down() -> void:
	relic_picked.emit($HBoxContainer/Button/AnimatedSprite2D.frame)
	get_tree().paused = false
	queue_free()

func _on_button_2_button_down() -> void:
	relic_picked.emit($HBoxContainer/Button2/AnimatedSprite2D2.frame)
	get_tree().paused = false
	queue_free()
