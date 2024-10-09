extends Area2D

var damage: float
var speed: float = 250

var duration_timer: Timer
var duration: float = 1.25

func _ready() -> void:
	duration_timer = Timer.new()
	add_child(duration_timer)
	duration_timer.one_shot = true
	duration_timer.timeout.connect(hit)
	duration_timer.start(duration)

func _physics_process(delta: float) -> void:
	#sets a vector pointed right, that will then be rotated
	#based on the enemy detection script
	var direction: Vector2 = Vector2.RIGHT.rotated(rotation)
	#moves the bullet in a given direction
	position += direction * speed * delta

#if bullet collides with something
func _on_area_entered(area: Area2D) -> void:
	hit()
	#if bullet hits an entity that takes damage
	if area.get_parent().has_method("take_damage"):
		#make entity take damage
		area.get_parent().take_damage(damage)

func hit():
	#play animation here later
	queue_free()
