extends CharacterBody2D

var speed: int = 400
var max_health: int = 25
var current_health: int = 25

var direction: Vector2
var mouse_pos: Vector2

@onready var health_bar: TextureProgressBar = $TextureProgressBar

func _ready() -> void:
	health_bar.max_value = max_health
	health_bar.value = current_health

func _physics_process(delta: float) -> void:
	movement()

func movement() -> void:
	#getting the player direction from input
	direction = Input.get_vector("walk_left","walk_right","walk_up","walk_down")
	velocity = direction.normalized() * speed
	mouse_pos = get_global_mouse_position()
	
	#move the player
	move_and_slide()

func update_health_bar() -> void:
	health_bar.max_value = max_health
	health_bar.value = current_health

func _take_damage(damage: int):
	current_health -= damage
	print(current_health)
	update_health_bar()
	if(current_health <= 0):
		#call end game screen
		get_tree().quit()
