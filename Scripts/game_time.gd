extends Control

var time: float = 0.0
var seconds: int = 0
var minutes: int = 0

var stopped: bool

func _process(delta: float) -> void:
	if !stopped:
		time += delta
		seconds = fmod(time, 60)
		minutes = fmod(time, 3600)/60
		$Time.text = "%02d:" % minutes + "%02d" % seconds
		

func time_stop() -> void:
	stopped = true
