extends Node
class_name attack

@export var damage: float # attack dmg
@export var duration: float # how long the projectile will travel
@export var size: float #size of the projectile
@export var cd: float #cooldown

#multipliers
var dmg_multi: float
var size_multi: float
var cd_reduct: float

var timer: Timer

func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.start(cd - (cd * cd_reduct))
	timer.timeout.connect(_attack)

func _attack() -> void:
	var bullet = preload("res://Scenes/attacks/generic_bullet.tscn")
	var new_bullet = bullet.instantiate()
	new_bullet.global_position = get_parent().global_position
	new_bullet.global_rotation = get_parent().global_rotation
	new_bullet.damage = damage + (damage * dmg_multi)
	print(new_bullet.damage)
	add_child(new_bullet)
	timer.start(cd - (cd * cd_reduct))
