extends Node
class_name attack

@export var damage: float = 5# attack dmg
@export var duration: float = 1# how long the projectile will travel
@export var cd: float = 1#cooldown

#multipliers
var dmg_multi: float = 0
var size_multi: float = 0
var cd_reduct: float = 0 # 0 - 9

# timer for the attack cooldown
var attack_cd: Timer

func _ready() -> void:
	var parent: CharacterBody2D = get_tree().get_first_node_in_group("player")
	if parent.has_signal("call_update_stats"):
		parent.call_update_stats.connect(_update_stats)
	
	#creates timer
	attack_cd = Timer.new()
	#adds timer as a child of the node
	add_child(attack_cd)
	#set timer to play only once
	attack_cd.one_shot = true
	#start timer with the correct cooldown values
	attack_cd.start(cd - (cd * cd_reduct))
	#connects the timer to the attack function
	attack_cd.timeout.connect(_attack)

func _update_stats(dmg_m: float, cd_r: float, size_m: float) -> void:
	dmg_multi = dmg_m
	cd_reduct = cd_r
	size_multi = size_m
	print("atualizado")

#called when attack_cd timer stops
func _attack() -> void:
	#loads the bullet scene
	var bullet: PackedScene = preload("res://Scenes/attacks/generic_bullet.tscn")
	#creates a new instance
	var new_bullet: Area2D = bullet.instantiate()
	#adds the correct values to the bullet
	new_bullet.global_scale = new_bullet.global_scale + (new_bullet.global_scale * size_multi)
	new_bullet.damage = damage + (damage * dmg_multi)
	new_bullet.global_position = get_parent().global_position
	new_bullet.global_rotation = get_parent().global_rotation
	#adds bullet to the scene
	add_child(new_bullet)

	#starts attack cooldown again
	attack_cd.start(cd - (cd * cd_reduct))
