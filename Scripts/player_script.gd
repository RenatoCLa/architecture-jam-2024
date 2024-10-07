extends CharacterBody2D

var speed :int = 400

var direction :Vector2
var mouse_pos :Vector2

func _physics_process(delta: float) -> void:
	movement()

func movement() -> void:
	#getting the player direction from input
	direction = Input.get_vector("walk_left","walk_right","walk_up","walk_down")
	velocity = direction.normalized() * speed
	mouse_pos = get_global_mouse_position()
	
	#move the player
	move_and_slide()
