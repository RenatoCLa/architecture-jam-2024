extends Control

@onready var score: Label = %Leaderboard_Score
@onready var username: Label = %Leaderboard_Name
@onready var kills: Label = %Leaderboard_Kills
@onready var time: Label = %Leaderboard_Time
@onready var level: Label = %Leaderboard_Level

func set_info(p_name, p_score, p_kills, p_time, p_level) -> void:
	username.text = p_name
	score.text = str("Score: ", p_score)
	kills.text = str("Kills: ", p_kills)
	time.text = str("Time: ", p_time)
	level.text = str("LV: ", p_level)
