extends Control

@export var up_name: Label
@export var icon: TextureRect
@export var description: Label

var parent: Control

var transfer_data

var id: int
var is_weapon: bool
var mouse_over: bool

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot") && mouse_over:
		print("hi")
		parent.call("on_upgrade_selected", transfer_data)

func _on_mouse_entered() -> void:
	mouse_over = true

func _on_mouse_exited() -> void:
	mouse_over = false

func set_data(data) -> void:
	#add pool of multiple upgrade names
	var type = data[0][0]
	var value:float = data[0][1]
	transfer_data = [type, value]
	match type:
		"dmg":
			up_name.text = "Strength"
			icon.texture = icon.texture # change for dmg icon
			description.text = str("+ ", value,"% bonus damage")
		"cd":
			up_name.text = "Haste"
			icon.texture = icon.texture # change for dmg icon
			description.text = str("+ ", value/25,"% reduced cooldowns")
		"speed":
			up_name.text = "Energy Drink"
			icon.texture = icon.texture # change for dmg icon
			description.text = str("+ ", value/50,"% bonus movement speed")
		"health":
			up_name.text = "Powerful Drugs"
			icon.texture = icon.texture # change for dmg icon
			description.text = str("+ ", value,"% bonus health")
