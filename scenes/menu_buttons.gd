extends MarginContainer
@export var help_menu_screen: MarginContainer

func toggle_visibility(object):
	if object.visible:
		object.visible = false
	else:
		object.visible = true
	
# Called when the node enters the scene tree for the first time.

func _on_toggle_help_menu_button_pressed() -> void:
	toggle_visibility(help_menu_screen)


func _on_start_button_pressed() -> void:
	print("buttonpressed")
	get_tree().change_scene_to_file("res://scenes/game.tscn")
