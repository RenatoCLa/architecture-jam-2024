extends Control

#VARIABLES

#Nodes
var parent: Control
@export var up_name: Label
@export var icon: TextureRect
@export var description: Label

#Upgrade information
var transfer_data: Array

#Booleans
var is_weapon: bool
var mouse_over: bool

#FUNCTIONS

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot") && mouse_over:
		parent.call("on_upgrade_selected", transfer_data)

func _on_mouse_entered() -> void:
	mouse_over = true

func _on_mouse_exited() -> void:
	mouse_over = false

func set_data(data: Array) -> void:
	#add pool of multiple upgrade names
	var type:String = data[0][0]
	
	var value:float = data[0][1]
	
	transfer_data = [type, value]
	
	match type:
		"dmg":
			up_name.text = "Stronger Bullets"
			icon.texture = load("res://Sprites/bullet_up.png")
			description.text = str("+ ", value,"% bonus damage")
			
		"cd":
			up_name.text = "Haste"
			icon.texture = load("res://Sprites/haste_up.png")
			description.text = str("+ ", snapped(value/5, 0.01),"% reduced cooldowns")
			
		"speed":
			up_name.text = "Energy Drink"
			icon.texture = load("res://Sprites/energy_up.png")
			description.text = str("+ ", snapped(value/5, 0.01),"% bonus movement speed")
			
		"health":
			up_name.text = "Healthy meal"
			icon.texture = load("res://Sprites/health_up.png")
			description.text = str("+ ", value,"% bonus health")
