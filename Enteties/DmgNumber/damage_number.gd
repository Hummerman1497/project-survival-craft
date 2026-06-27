extends Node2D

@onready var label: Label = $Label
var text: String = "0"

func _ready() -> void:
	label.text = text
	z_index = 100	
	
	var random_x_flight = randf_range(-20.0, 20.0)
	
	var tween = create_tween().set_parallel(true)	
	tween.tween_property(self, "position:y", position.y - 60, 1)# Fliegt in 0.5 Sekunden um 50 Pixel nach oben
	tween.tween_property(self, "position:x", position.x + random_x_flight, 1)	
	tween.tween_property(self, "modulate:a", 0.6, 1)	# Blendet sich gleichzeitig aus	
	tween.chain().tween_callback(queue_free)# Löscht sich selbst, wenn der Tween fertig ist
