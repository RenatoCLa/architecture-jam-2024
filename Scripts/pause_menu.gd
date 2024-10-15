extends Control

func _ready() -> void:
	$Background/Options/Continue.grab_focus()
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
	var lb_ref = load("res://Scenes/Menus/leaderboard.tscn")
	var lb_node = lb_ref.instantiate()
	get_tree().get_root().add_child(lb_node)

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menus/Main_menu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
