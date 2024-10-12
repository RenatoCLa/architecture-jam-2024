extends CanvasLayer

@onready var score_card_ref: PackedScene = load("res://Scenes/Menus/score_card.tscn")

@onready var score_container = %LB_Score_Container

func _ready() -> void:
	get_tree().paused = true
	generate_score_list()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		queue_free()

func generate_score_list() -> void:
	if get_scores().is_empty():
		pass
	else:
		var size = get_scores()["scores"].size()
		
		for i in range(size):
			var scores = get_scores()["scores"][i]
			
			var score_card = score_card_ref.instantiate()
			
			var u_name = scores["name"]
			var score = scores["score"]
			var kills = scores["kills"]
			var time = scores["time"]
			var level = scores["level"]
			
			score_container.add_child(score_card)
			
			score_card.set_info(u_name,score,kills,time,level)

func get_scores() -> Dictionary:
	if FileAccess.file_exists("user://lb-data.json"):
		var file = FileAccess.open("user://lb-data.json", FileAccess.READ)
		var dict:Dictionary = JSON.parse_string(file.get_as_text())
		return dict
	else:
		return {}

func _on_close_pressed() -> void:
	queue_free()
