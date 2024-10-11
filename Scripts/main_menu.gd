extends Control

#load level
@onready var level = preload("res://Scenes/rooms/enemy_spawner_test_room.tscn")

func _ready() -> void:
	get_tree().paused = false
	$Options/Play.grab_focus()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(level)

func _on_leaderboard_pressed() -> void:
	pass # Replace with function body.

func _on_options_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit()
