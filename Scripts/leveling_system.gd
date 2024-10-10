extends Node

var level: int = 1
var current_xp: int = 0
var xp_treshold: int = 1
var xp_increase: int = 1
var xp_increase_multi: int = 0.5
@onready var ui_h = $"../GUI"

@export var upgrade_menu = preload("res://Scenes/level_up_choices.tscn")

var window_opened = false

func gain_exp(xp: int) -> void:
	current_xp += xp
	check_exp()

func closed_window() -> void:
	if !ui_h.get_child(0):
		get_tree().set_pause(false)
		window_opened = false
		check_exp()
	else:
		if get_tree():
			get_tree().create_timer(1).timeout.connect(closed_window)

func check_exp() -> void:
	if(current_xp >= xp_treshold) && !window_opened:
		level += 1
		current_xp -= xp_treshold
		level_up()

func level_up() -> void:
	#bring up leveling choice UI
	increase_xp_treshold()
	var parent = get_parent()
	#leveled_up.emit(parent.weapon_slots, parent.weapon_list)
	print("level ", level)
	pop_up_option()

func pop_up_option() -> void:
	var menu = upgrade_menu.instantiate()
	menu.connect("closed", closed_window)
	ui_h.add_child(menu)
	window_opened = true

func increase_xp_treshold() -> void:
	var temp_xp_increase = xp_increase * xp_increase_multi
	print(xp_treshold, " ", xp_increase, " ", temp_xp_increase)
	xp_treshold += xp_increase + temp_xp_increase
	print(xp_treshold)
	xp_increase = temp_xp_increase
