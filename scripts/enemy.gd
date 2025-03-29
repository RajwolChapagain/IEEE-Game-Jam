extends Player

func load_new_enemy(resource: EnemyStats):
	hp = resource.max_hp
	$HealthBar.max_value = hp
	$HealthBar.value = hp
	$Portrait.texture = resource.portrait
