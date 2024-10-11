extends CharacterBody2D
class_name Enemy

#VARIABLES

#Enemy stats
@export var speed: float = 25
var max_health: float
@export var health: float = 10
@export var damage: float = 2
@export var xp: int = 5

#Stats multiplier
var dmg_multi: float = 0
var hp_multi: float = 0
var speed_multi: float = 0
var size_multi: float = 0
var xp_multi: float = 0

#Booleans
var can_attack: bool = false

#Vectors
var direction: Vector2
var player_pos: Vector2

#Nodes
var player: CharacterBody2D
@onready var wave_manager: Node2D = get_parent()
@onready var attack_cd: Timer = $Attack_CD
@onready var health_bar: TextureProgressBar = $HealthBar

#FUNCTIONS

func _ready() -> void:
	#apply the stat multipliers
	stat_multiplier()
	health_bar.max_value = health
	update_health_bar()
	
	#timer setup
	attack_cd.process_mode = ProcessMode.PROCESS_MODE_PAUSABLE

func _physics_process(_delta: float) -> void:
	#moves the enemy
	movement()
	#if the enemy can attack, call attack function
	if can_attack == true:
		attack()

func stat_multiplier() -> void:
	global_scale += global_scale * size_multi
	health += health * hp_multi
	max_health = health

#ENEMY LOGIC

func movement() -> void:
	#get players position
	player_pos = wave_manager.player_pos
	#calculate the direction to reach player
	direction = global_position.direction_to(player_pos)
	#calculate the enemy velocity
	velocity = direction.normalized() * (speed + (speed * speed_multi))
	#move towards that direction
	move_and_slide()

func attack() -> void:
	#if attack is not on cooldown
	if attack_cd.is_stopped():
		#call the _take_damage function on the player node
		var dmg: float = damage + (damage * dmg_multi)
		player.call("_take_damage", dmg)
		print("attack!")
		#starts attack cooldown
		attack_cd.start(.15)

func take_damage(dmg: float) -> void:
	#decreases hp based on the damage taken
	health -= dmg
	update_health_bar()
	#if health is depleted
	if(health <= 0):
		#call death function
		die()

func die() -> void:
	#removes enemy from scene, should play a death animation first
	#calculates gained XP for the player
	
	var gained_xp: int = xp + int(roundf((xp * xp_multi))) + 1
	
	#deletes the enemy
	queue_free()
	
	#give xp to player
	player.propagate_call("gain_exp", [gained_xp])
	
	#send signal to wave manager
	wave_manager.call("on_entity_death")
	print("xp: ", gained_xp)

#UI LOGIC

func update_health_bar() -> void:
	health_bar.value = health
	health_display()

func health_display() -> void:
	if health == max_health:
		health_bar.hide()
	else:
		health_bar.show()

#COLLISION LOGIC

func _on_hitbox_area_entered(area: Area2D) -> void:
	var body: Node2D = area.get_parent()
	#if collided with player
	if body.is_in_group("player"):
		print("ready")
		#becomes able to attack the player, as they are in range
		can_attack = true

func _on_hitbox_area_exited(area: Area2D) -> void:
	var body: CharacterBody2D = area.get_parent()
	if body.is_in_group("player"):
		print("out of range")
		#cannot attack anymore as player is out of range
		can_attack = false
		
		#resets the attack cooldown
		attack_cd.stop()
