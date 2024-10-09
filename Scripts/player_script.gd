extends CharacterBody2D

signal call_update_stats()

#stats
var speed: float = 150
var max_health: float = 100
var current_health: float

#stats multipliers
var hp_multi: float = 0
var dmg_multi: float = 0
var speed_multi: float = 2
var size_multi: float = 0
var cd_reduct: float = 0

#holds the player weapons
var weapon_slots: Array[int]
@export var weapon_list: JSON

var direction: Vector2

#nodes
@onready var health_bar: TextureProgressBar = $HealthBar

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("dodge"):
		_add_weapon(1)

func _ready() -> void:
	#makes the player be full hp
	current_health = max_health
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

func update_stats() -> void:
	#call this everytime a stat bonus is received
	#used to make sure every function that needs these
	#stats will have the current stat and not a previous
	#one
	call_update_stats.emit(dmg_multi, cd_reduct, size_multi)
	pass

func _add_weapon(id: int) -> void:
	#checks how many weapons player has
	var size: int = weapon_slots.size()
	#if player has 4 weapons, don't add another weapon
	#as the player inventory is full
	if size >= 4:
		#maybe let player swap weapons
		pass
	#if player inventory is not full
	else:
		#gets list of all weapons
		var data: Dictionary = weapon_list.data.weapons[id]
		var weapon_id: int = data.id
		#gets current free inv slot
		var slot: Node = $Holster.get_child(size)
		#gets script dir
		var script: String = str(data.script)
		#sets attack script to weapon slot
		slot.set_script(load(script))
		slot.call("_ready")
		weapon_slots.append(weapon_id)
		print(weapon_slots)
		#change slot name to fit weapon name
		slot.name += "-" + data.name
		update_stats()

func update_health_bar() -> void:
	#this is meant to be called everytime any health
	#related stat is changed, so the health bar can
	#accuratly display hp information
	health_bar.max_value = max_health
	health_bar.value = current_health

func _take_damage(damage: int) -> void:
	#reduces hp based on amount of damage taken
	current_health -= damage
	print(current_health)
	#updates healthbar to acuratly display new hp
	update_health_bar()
	#if health is depleted
	if(current_health <= 0):
		#add death animation
		#freeze game
		#call end game screen
		get_tree().quit()
