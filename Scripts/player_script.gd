extends CharacterBody2D

#SIGNALS

signal call_update_stats()

#VARIABLES

#Stats
var speed: float = 150
var base_speed: float = 150
var max_health: float = 1
var base_max_health: float = 100
var base_current_health: float
var current_health: float

var kill_count: int

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
@onready var time_tracker = $GUI/Time_Control
@onready var GUI = $GUI

#Preloadede Scenes
@onready var pause_menu = preload("res://Scenes/Menus/pause_menu.tscn")
@onready var game_over_screen = preload("res://Scenes/Menus/game_over_screen.tscn")

#FUNCTIONS

func _ready() -> void:
	#max out player health
	current_health = max_health
	base_current_health = base_max_health
	
	#sets the values in the hp bar to match the player
	health_bar.max_value = max_health
	health_bar.value = current_health
	update_health_bar()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		var menu = pause_menu.instantiate()
		$GUI.add_child(menu)

func _physics_process(_delta: float) -> void:
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
	if current_health == max_health:
		max_health = base_max_health + (base_max_health * hp_multi)
		current_health = max_health
	else:
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
	health_display()

func _take_damage(damage: int) -> void:
	#reduces hp based on amount of damage taken
	current_health -= damage
	#updates healthbar to acuratly display new hp
	update_health_bar()
	#if health is depleted
	if(current_health <= 0):
		die()

func health_display() -> void:
		#hide health bar if health is full
	if current_health == max_health:
		health_bar.hide()
	else:
		#shows health bar if health is not full
		health_bar.show()

func die() -> void:
	#add death animation
	var game_over = game_over_screen.instantiate()
	
	game_over.kill_count = kill_count
	game_over.sec = time_tracker.seconds
	game_over.min = time_tracker.minutes
	game_over.total_sec = int(roundf(time_tracker.time))
	game_over.level = $XP.level
	
	time_tracker.time_stop()
	GUI.add_child(game_over)
