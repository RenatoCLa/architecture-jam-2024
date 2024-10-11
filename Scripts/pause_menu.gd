extends Control

func _ready() -> void:
	$Background/Options/Play.grab_focus()
	get_tree().paused = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		close_menu()
		get_viewport().set_input_as_handled()

func _on_play_pressed() -> void:
	close_menu()

func close_menu() -> void:
	get_tree().paused = false
	queue_free()

func _on_leaderboard_pressed() -> void:
	pass # Replace with function body.

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/rooms/Main_menu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
