extends Area2D

func _physics_process(delta: float) -> void:
	#looks for enemies in range
	var enemies_in_range = get_overlapping_areas()
	#if there's enemies in range
	if enemies_in_range.size() > 0:
		#get enemy that is closest to player
		var target_enemy = enemies_in_range.front()
		#change the rotation of the node, to aim 
		#at the enemy
		look_at(target_enemy.global_position)
