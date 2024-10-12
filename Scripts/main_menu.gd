extends Control

#load level
@onready var level = preload("res://Scenes/rooms/enemy_spawner_test_room.tscn")

func _ready() -> void:
	get_tree().paused = false
	$Options/Play.grab_focus()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(level)

func _on_leaderboard_pressed() -> void:
	var lb_ref = load("res://Scenes/Menus/leaderboard.tscn")
	var lb_node: CanvasLayer = lb_ref.instantiate()
	lb_node.tree_exited.connect(unpause)
	get_tree().get_root().add_child(lb_node)

func unpause() -> void:
	if get_tree():
		get_tree().paused = false

func _on_options_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit()
