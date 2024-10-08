extends Area2D

var damage: float
var speed: float

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Vector2.RIGHT.rotated(rotation)
	position += direction * 500 * delta

func _on_area_entered(area: Area2D) -> void:
	queue_free()
	if area.get_parent().has_method("take_damage"):
		area.get_parent().take_damage(damage)
