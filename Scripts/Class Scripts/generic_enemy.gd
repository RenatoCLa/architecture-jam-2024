extends CharacterBody2D
class_name Enemy

#enemy attributes
@export var speed: float = 25
@export var health: float = 10
@export var damage: float = 2

#booleans
var can_attack: bool = false

var direction: Vector2
var player_pos: Vector2

var player_node: CharacterBody2D

@onready var attack_cd: Timer = $Attack_CD
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	movement()
	if can_attack == true:
		attack()

func movement() -> void:
	player_pos = player.global_position
	direction = global_position.direction_to(player_pos)
	velocity = direction * speed
		
	move_and_slide()

func attack() -> void:
	if attack_cd.is_stopped():
		player_node.call("_take_damage", damage)
		print("attack!")
		attack_cd.start(.15)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_node = body
		print("ready")
		can_attack = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_node = null
		print("out of range")
		can_attack = false
		attack_cd.stop()

func take_damage(dmg: float) -> void:
	health -= dmg
	if(health <= 0):
		die()

func die() -> void:
	queue_free()
	#drop exp
	#play death animation
