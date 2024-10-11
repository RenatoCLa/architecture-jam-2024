extends Area2D

#enemy detection logic
func _physics_process(delta: float) -> void:
	#looks for enemies in range
	var enemies_in_range = get_overlapping_areas()
	
	#if there's any enemies in range
	if enemies_in_range.size() > 0:
		#get enemy that is closest to player
		var target_enemy = enemies_in_range.front()
		
		#rotates the weapon node to point at the enemy
		look_at(target_enemy.global_position)
