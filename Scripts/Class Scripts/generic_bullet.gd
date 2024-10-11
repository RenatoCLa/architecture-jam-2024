extends Area2D

#VARIABLES

#bullet stats
var damage: float
var speed: float = 250

#timer variables
@onready var duration_timer: Timer = Timer.new()
var duration: float = 1.5 #lifetime of the bullet

#FUNCTIONS

func _ready() -> void:
	#add timer to scene
	add_child(duration_timer)
	
	#timer setup
	duration_timer.process_mode = Node.PROCESS_MODE_PAUSABLE
	duration_timer.one_shot = true
	duration_timer.timeout.connect(hit)
	duration_timer.start(duration)

#bullet travel
func _physics_process(delta: float) -> void:
	#sets a vector2 pointed right, that will then be rotated to aim at an enemy
	var direction: Vector2 = Vector2.RIGHT.rotated(rotation)
	#moves the bullet in a given direction
	position += direction * speed * delta

#COLLISION FUNCTIONS

#if bullet collides with something
func _on_area_entered(area: Area2D) -> void:
	#if bullet hits an entity that takes damage
	if area.get_parent().has_method("take_damage"):
		#make entity take damage
		area.get_parent().take_damage(damage)
		hit()

func hit():
	#play animation here later
	queue_free()
