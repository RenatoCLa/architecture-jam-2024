extends CanvasLayer

@onready var label: Label = $Label
var x

func _ready() -> void:
	zoom_foward()
	label.text = "WAVE "
	label.label_settings
	
func zoom_foward() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(label.label_settings, "font_size", 60, 1.5)
	tween.tween_property(label, "modulate", Color.TRANSPARENT, .5)
	tween.tween_callback(queue_free)
