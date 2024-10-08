extends CharacterBody2D

#stats
var speed: float = 150
var max_health: float = 10000000000000000
var current_health: float

#stats multipliers
var hp_multi: float
var dmg_multi: float
var speed_multi: float
var aoe_multi: float
var cd_reduct: float 

var weapon_slots: Array[int]

var direction: Vector2
var mouse_pos: Vector2

@onready var health_bar: TextureProgressBar = $HealthBar

func _ready() -> void:
	current_health = max_health
	health_bar.max_value = max_health
	health_bar.value = current_health
	_add_weapon()

func _physics_process(delta: float) -> void:
	if current_health == max_health:
		health_bar.hide()
	else:
		health_bar.show()
	movement()

func movement() -> void:
	#getting the player direction from input
	direction = Input.get_vector("walk_left","walk_right","walk_up","walk_down")
	velocity = direction.normalized() * speed
	mouse_pos = get_global_mouse_position()
	
	#move the player
	move_and_slide()

func update_stats() -> void:
	pass

func _add_weapon() -> void:
	var size = weapon_slots.size()
	if size == 3:
		#full
		#maybe let player swap weapons
		pass
	else:
		#add weapon
		pass

func update_health_bar() -> void:
	health_bar.max_value = max_health
	health_bar.value = current_health

func _take_damage(damage: int) -> void:
	current_health -= damage
	print(current_health)
	update_health_bar()
	if(current_health <= 0):
		#call end game screen
		get_tree().quit()
