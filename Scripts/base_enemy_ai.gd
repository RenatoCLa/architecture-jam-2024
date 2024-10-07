extends CharacterBody2D
class_name EnemyBase

#enemy attributes
var speed: int = 250
var health: int = 10
var damage: int = 2

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

func movement():
	player_pos = player.global_position
	if !(global_position.distance_to(player_pos) < 15):
		direction = global_position.direction_to(player_pos)
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO
		
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
