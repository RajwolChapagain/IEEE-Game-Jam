extends AnimatedSprite2D

var enemy_frame_index:int = 0:
	set(ind):
		update()
func _ready():
	update()

func update():
	frame = enemy_frame_index
