extends Control

signal closed

@export var upgrade_option: PackedScene = preload("res://Scenes/upgrade_option.tscn")
@export var upgrade_holder: HBoxContainer

var up_pool: Array[String] = ["dmg", "speed", "cd", "health"]

var player
var rng: RandomNumberGenerator

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	rng = RandomNumberGenerator.new()
	get_tree().set_pause(true)
	decide_card_amount()

func decide_card_amount() -> void:
	rng.randomize()
	var amount = [1, 2, 3, 4][rng.rand_weighted([0.05, 0.5, 5, 0.1])]
	spawn_choices(amount)

func choose_upgrade():
	rng.randomize()
	var type = up_pool.pick_random()
	var value = [1, 5, 10, 15, 20, 25][rng.rand_weighted([.1, 3, 2, 1, .5, .1])]
	return [type, value]

func spawn_choices(choices: int) -> void:
	var n_choices = 0
	while n_choices < choices:
		var options = upgrade_option.instantiate()
		upgrade_holder.add_child(options)
		var up_data = choose_upgrade()
		options.parent = self
		options.call("set_data", [up_data])
		n_choices += 1

func on_upgrade_selected(data) -> void:
	player.update_multiplier(data)
	queue_free()

func _on_tree_exited() -> void:
	closed.emit()
