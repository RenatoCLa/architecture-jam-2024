extends Control

#SIGNALS

signal closed

#VARIABLES

#Nodes
var player: CharacterBody2D
var rng: RandomNumberGenerator

#Onready Nodes
@export var upgrade_option: PackedScene = preload("res://Scenes/upgrade_option.tscn")
@export var upgrade_holder: HBoxContainer

#Upgrade choice Pool
var up_pool: Array[String] = ["dmg", "speed", "cd", "health"]

#FUNCTIONS

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	rng = RandomNumberGenerator.new()
	get_tree().set_pause(true) #pause the game
	decide_card_amount() #how many upgrade cards there will be in the menu

func decide_card_amount() -> void:
	rng.randomize()
	var amount = [1, 2, 3, 4][rng.rand_weighted([0.05, 0.5, 5, 0.1])]
	spawn_choices(amount)

func spawn_choices(choices: int) -> void:
	var n_choices = 0
	rng.randomize()
	#loop until all cards are created
	while n_choices < choices:
		var options = upgrade_option.instantiate()
		upgrade_holder.add_child(options)
		
		var up_data = choose_upgrade() #randomly picks a upgrade for the card
		options.parent = self
		options.call("set_data", [up_data]) #sends upgrade data to the card
		n_choices += 1

func choose_upgrade() -> Array:
	#rework this
	var type = up_pool.pick_random()
	var value = [15, 25, 50, 75, 100][rng.rand_weighted([3, 2, 1, .5, .1])]
	return [type, value]

func on_upgrade_selected(data) -> void:
	player.update_multiplier(data) #give the upgrade benefits to the player
	queue_free()

func _on_tree_exited() -> void:
	#call a signal when menu is closed
	closed.emit()
