extends Node

#VARIABLES

#LVL Stats
var level: int = 1
var current_xp: int = 0
var xp_treshold: int = 1
var xp_increase: int = 1
var xp_increase_multi: int = 0.5

#Booleans
var window_opened = false

#Nodes
@onready var level_display = $"../GUI/Level"
@onready var ui_h = $"../POP_UP_GUI"
@export var upgrade_menu = preload("res://Scenes/level_up_choices.tscn")

#FUNCTIONS

func _ready() -> void:
	update_display()

#Check if the Level Up UI is closed, if it is, allow another one to spawn
#this is meant for scenarios where you level up multiple times in a row, so that
#each upgrade window waits for the previous one to close
func closed_window() -> void:
	#if there's no window opened
	if ui_h.get_child_count() == 0:
		#unpause game
		get_tree().set_pause(false)
		window_opened = false
		#check if you can level up again
		check_exp()
	else: #if there's one window already, wait until it closes
		if get_tree():
			get_tree().create_timer(1, false).timeout.connect(closed_window)

func gain_exp(xp: int) -> void:
	current_xp += xp #gains experience
	check_exp() #check if can level up

func check_exp() -> void:
	#if experience exceeds the treshold
	if(current_xp >= xp_treshold):
		#carry over remaining exp
		current_xp -= xp_treshold
		
		#level up
		level += 1
		level_up()

func level_up() -> void:
	increase_xp_treshold() #increase level up experience requirement
	update_display()
	print("Current level: ", level)
	#bring up Upgrade Selection UI
	pop_up_options()

func increase_xp_treshold() -> void:
	var temp_xp_increase = xp_increase * xp_increase_multi
	xp_treshold += xp_increase + temp_xp_increase
	xp_increase = temp_xp_increase

func pop_up_options() -> void:
	#creates an instance of the upgrade menu
	var menu = upgrade_menu.instantiate()
	
	menu.connect("closed", closed_window)
	
	#add menu to the upgrade selection UI
	ui_h.add_child(menu)
	window_opened = true

func update_display() -> void:
	level_display.text = "LEVEL %d" % level
