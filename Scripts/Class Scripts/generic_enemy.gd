extends CharacterBody2D
class_name Enemy

#enemy attributes
@export var speed: float = 25
@export var health: float = 10
@export var damage: float = 2

#multiplier
var dmg_multi: float = 0
var hp_multi: float = 0
var speed_multi: float = 0
var size_multi: float = 0

#booleans
var can_attack: bool = false

#vectors
var direction: Vector2
var player_pos: Vector2

var player_node: CharacterBody2D

@onready var attack_cd: Timer = $Attack_CD
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	global_scale += global_scale * size_multi

func _physics_process(_delta: float) -> void:
	#moves the enemy
	movement()
	#if the enemy can attack, call attack function
	if can_attack == true:
		attack()

func movement() -> void:
	#get players position
	player_pos = player.global_position
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
		player_node.call("_take_damage", dmg)
		print("attack!")
		#starts attack cooldown
		attack_cd.start(.15)

#checks if player collided with enemy hitbox
func _on_area_2d_body_entered(body: Node2D) -> void:
	#if collision is from player
	if body.is_in_group("player"):
		#load the player node into a variable
		player_node = body
		print("ready")
		#becomes able to attack the player, as they are
		#in range
		can_attack = true

#once player leaves the area
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		#clear player node variable
		player_node = null
		print("out of range")
		#cannot attack anymore as player is out of range
		can_attack = false
		#resets the attack cooldown
		attack_cd.stop()

func take_damage(dmg: float) -> void:
	#decreases hp based on the damage taken
	health -= dmg
	#if health is depleted
	if(health <= 0):
		#call death function
		die()

func die() -> void:
	#removes enemy from scene, should play a death anim
	#first
	queue_free()
	#drop exp or give exp directly to player
	#play death animation
