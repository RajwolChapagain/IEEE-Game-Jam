extends MarginContainer
@export var help_menu_screen: MarginContainer
signal music_toggled

func toggle_visibility(object):
	if object.visible:
		object.visible = false
	else:
		object.visible = true
	
# Called when the node enters the scene tree for the first time.



func _on_toggle_help_menu_button_pressed() -> void:
	toggle_visibility(help_menu_screen)


func _on_start_button_pressed() -> void:
	$"../Cheshire/CheshireAnimationPlayer".play("OpenMouth")
	await $"../Cheshire/CheshireAnimationPlayer".animation_finished
	var cardTween = create_tween()
	var titleTween = create_tween()
	cardTween.tween_property($StartButton/HBoxContainer/StartButton,"modulate:a",0,1)
	titleTween.tween_property($"../title","scale", Vector2(0,0),1)
	titleTween.set_parallel()
	titleTween.tween_property($"../title","global_position", Vector2(480,270),0.3)
	titleTween.tween_property($"../title","modulate:a",0,1)
	await cardTween.finished
	$"../Cheshire/CheshireAnimationPlayer".play("CloseMouth")
	await $"../Cheshire/CheshireAnimationPlayer".animation_finished
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_sound_button_toggled(toggled_on):
	Utils.muted = !Utils.muted
	music_toggled.emit()
