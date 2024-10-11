extends CharacterBody2D

#SIGNALS

signal call_update_stats()

#VARIABLES

#Stats
var speed: float = 150
var base_speed: float = 150
var max_health: float = 100
var base_max_health: float = 100
var base_current_health: float
var current_health: float

#Stats multipliers
var hp_multi: float = 0
var dmg_multi: float = 0
var speed_multi: float = 0
var size_multi: float = 0
var cd_reduct: float = 0

#weapon inventory
var weapon_slots: Array[int]

#Vectors
var direction: Vector2

#Nodes
@onready var health_bar: TextureProgressBar = $HealthBar
@onready var spawn_range = $"Camera2D/Spawn Area/Spawn Range"
@onready var spawn_point = $"Camera2D/Spawn Area/Spawn Range/Spawn Point"

#FUNCTIONS

func _ready() -> void:
	#max out player health
	current_health = max_health
	base_current_health = base_max_health
	
	#sets the values in the hp bar to match the player
	health_bar.max_value = max_health
	health_bar.value = current_health

func _physics_process(_delta: float) -> void:
	#hide health bar if health is full
	if current_health == max_health:
		health_bar.hide()
	else:
		#shows health bar if health is not full
		health_bar.show()
	#calls the movement function
	movement()

func movement() -> void:
	#getting the player direction from input
	direction = Input.get_vector("walk_left","walk_right","walk_up","walk_down")
	#calculates velocity based on direction and speed
	velocity = direction.normalized() * (speed + (speed * speed_multi))
	
	#moves the player
	move_and_slide()

func update_multiplier(data) -> void:
	var type = data[0] #type of upgrade
	var value: float = data[1] #upgrade values
	match type:
		"dmg":
			dmg_multi += value/100
		"health":
			hp_multi += value/100
		"cd":
			cd_reduct += (value/100)/25
			cd_reduct = clampf(cd_reduct, 0.0, 0.85) #limit how much cdr you have
		"speed":
			speed_multi += (value/100)/50
	update_stats()

func update_stats() -> void:
	#call this everytime a stat bonus is received
	#used to make sure every function that needs these stats will have the 
	#current stat and not a previous one
	max_health = base_max_health + (base_max_health * hp_multi)
	speed = speed + (speed * speed_multi)
	speed = clampf(speed, 0.0, 1500.0) #limit how fast you can go
	call_update_stats.emit(dmg_multi, cd_reduct, size_multi)
	update_health_bar()

func update_health_bar() -> void:
	#this is meant to be called everytime any health
	#related stat is changed, so the health bar can
	#accuratly display hp information
	health_bar.max_value = max_health
	health_bar.value = current_health

func _take_damage(damage: int) -> void:
	#reduces hp based on amount of damage taken
	current_health -= damage
	#updates healthbar to acuratly display new hp
	update_health_bar()
	#if health is depleted
	if(current_health <= 0):
		#add death animation
		#freeze game
		#call end game screen
		get_tree().quit()
