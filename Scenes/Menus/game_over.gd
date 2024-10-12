extends Control

@onready var time_display = %"Run Time Display"
@onready var kill_display = %"Run Kill Display"

@onready var time_title = %"Run Time Title"
@onready var kill_title = %"Run Kill Title"

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

var playing_anim: bool = false

func _ready() -> void:
	#self.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	get_tree().paused = true
	var min_s: String = str(min)
	var sec_s: String = str(sec)
	
	if min < 10:
		min_s = str(0,min_s)
	if sec < 10:
		sec_s = str(0,sec_s)
	
	e_min_1 = int(min_s[0])
	e_min_2 = int(min_s[1])
	e_sec_1 = int(sec_s[0])
	e_sec_2 = int(sec_s[1])
	
	playing_anim = true
	game_over_screen_animation()

func _physics_process(delta: float) -> void:
	if playing_anim:
		time_display.text = str(min_1, min_2, ":", sec_1, sec_2)
		
		kill_display.text = str(kills)

func game_over_screen_animation() -> void:
	tween.tween_property(time_title, "modulate", Color.WHITE, 1)
	tween.tween_property(time_display, "modulate", Color.WHITE, 1)

	time_animation()
	
	tween.tween_property(kill_title, "modulate", Color.WHITE, 1)
	tween.tween_property(kill_display, "modulate", Color.WHITE, 1)
	
	kill_count_animation()

func time_animation() -> void:
	
	tween.tween_property(self, "min_2", e_min_2, .3)
	tween.tween_property(self, "min_1", e_min_1, .3)
	tween.tween_property(self, "sec_2", e_sec_2, .3)
	tween.tween_property(self, "sec_1", e_sec_1, .3)

func kill_count_animation() -> void:
	tween.tween_property(self, "kills", kill_count, 1.5)
	tween.tween_property(self, "playing_anim", false, 0)
