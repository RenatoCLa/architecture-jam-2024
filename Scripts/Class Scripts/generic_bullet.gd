extends Area2D

var damage: float
var speed: float = 500

func _physics_process(delta: float) -> void:
	#sets a vector pointed right, that will then be rotated
	#based on the enemy detection script
	var direction: Vector2 = Vector2.RIGHT.rotated(rotation)
	#moves the bullet in a given direction
	position += direction * speed * delta

#if bullet collides with something
func _on_area_entered(area: Area2D) -> void:
	#destroyes the bullet
	queue_free()
	#if bullet hits an entity that takes damage
	if area.get_parent().has_method("take_damage"):
		#make entity take damage
		area.get_parent().take_damage(damage)
