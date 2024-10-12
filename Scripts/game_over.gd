extends Control

@onready var time_display = %"Run Time Display"
@onready var kill_display = %"Run Kill Display"
@onready var score_display = %"Run Score Display"

@onready var time_title = %"Run Time Title"
@onready var kill_title = %"Run Kill Title"
@onready var score_title = %"Run Score Title"

@onready var save_button: Button = %"Run Save Score"
@onready var quit_button: Button = %"Quit Game"
@onready var menu_button: Button = %"Main Menu"

@onready var button_container = $"Status Screen/Control/HBoxContainer"

var tween: Tween

#Values for the status animation

var min_1 = 0
var min_2 = 0
var sec_1 = 0
var sec_2 = 0

var kills: int = 0

#end value of the animation
var e_min_1 = 0
var e_min_2 = 0
var e_sec_1 = 0
var e_sec_2 = 0

var e_kills: int = 0

#Player statistics

var kill_count: int
var min: int
var sec: int
var total_sec: int

var level: int
var score: int
var score_points: int
var time_point: int = 7
var kill_point: int = 12

var time_string: String

var playing_anim: bool = false

func _ready() -> void:
	#self.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	self.modulate = Color.TRANSPARENT
	tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	get_tree().paused = true
	var min_s: String = str(min)
	var sec_s: String = str(sec)
	
	if min < 10:
		min_s = str(0,min_s)
	if sec < 10:
		sec_s = str(0,sec_s)
	
	time_string = min_s + ":" + sec_s
	
	e_min_1 = int(min_s[0])
	e_min_2 = int(min_s[1])
	e_sec_1 = int(sec_s[0])
	e_sec_2 = int(sec_s[1])
	
	calculate_score()
	
	playing_anim = true
	game_over_screen_animation()

func _physics_process(delta: float) -> void:
	if playing_anim:
		time_display.text = str(min_1, min_2, ":", sec_1, sec_2)
		
		kill_display.text = str(kills)
		
		score_display.text = str(score_points)

func game_over_screen_animation() -> void:
	
	tween.tween_property(self, "modulate", Color.WHITE, .4)
	tween.tween_property(button_container, "modulate", Color.WHITE, .2)
	tween.tween_property(menu_button, "disabled", false, 0)
	tween.tween_property(quit_button, "disabled", false, 0)
	tween.tween_property(time_title, "modulate", Color.WHITE, .4)
	tween.tween_property(time_display, "modulate", Color.WHITE, .4)
	
	

	time_animation()
	
	tween.tween_property(kill_title, "modulate", Color.WHITE, .4)
	tween.tween_property(kill_display, "modulate", Color.WHITE, .4)
	
	kill_count_animation()
	
	tween.tween_property(score_title, "modulate", Color.WHITE, .5)
	tween.tween_property(score_display, "modulate", Color.WHITE, .5)
	
	score_animation()
	
	tween.tween_property(self, "playing_anim", false, 0)

func time_animation() -> void:
	
	tween.tween_property(self, "sec_2", e_sec_2, .2)
	tween.tween_property(self, "sec_1", e_sec_1, .2)
	tween.tween_property(self, "min_2", e_min_2, .2)
	tween.tween_property(self, "min_1", e_min_1, .2)

func kill_count_animation() -> void:
	tween.tween_property(self, "kills", kill_count, 1)

func score_animation() -> void:
	tween.tween_property(self, "score_points", score, .3)
	
	tween.tween_property(save_button, "modulate", Color.WHITE, .5)
	tween.tween_property(save_button, "disabled", false, 0)

func calculate_score() -> void:
	score = total_sec * time_point
	score += kill_count * kill_point

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menus/Main_menu.tscn")

func _on_save_score_pressed() -> void:
	var score_info = {
		"name": pick_score_name(),
		"score": score,
		"level": level,
		"kills": kill_count,
		"time": time_string
		}
	save(score_info)
	save_button.queue_free()

func save(data) -> void:
	var scores_dict = {
		"scores": []
	}
	
	if FileAccess.file_exists("user://lb-data.json"):
		scores_dict = load_file()
	
	scores_dict["scores"].append(data)

	var file= FileAccess.open("user://lb-data.json",FileAccess.WRITE)
	file.store_line(JSON.stringify(scores_dict))
	file.close()

func load_file() -> Dictionary:
	var file = FileAccess.open("user://lb-data.json", FileAccess.READ)
	var dict:Dictionary = JSON.parse_string(file.get_as_text())
	print("DICT", dict)
	return dict

func pick_score_name() -> String:
	return ""
