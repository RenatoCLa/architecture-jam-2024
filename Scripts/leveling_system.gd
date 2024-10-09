extends Node

var level: int = 1
var current_xp: int = 0
var xp_treshold: int = 50
var xp_increase: int = 15
var xp_increase_multi: int = 0.05

func gain_exp(xp: int) -> void:
	current_xp += xp
	if(current_xp >= xp_treshold):
		level += 1
		level_up()

func level_up() -> void:
	#bring up leveling choice UI
	current_xp -= xp_treshold
	increase_xp_treshold()
	print(level)

func increase_xp_treshold() -> void:
	var temp_xp_increase = xp_increase * xp_increase_multi
	print(xp_treshold, " ", xp_increase, " ", temp_xp_increase)
	xp_treshold += xp_increase + temp_xp_increase
	print(xp_treshold)
	xp_increase = temp_xp_increase
