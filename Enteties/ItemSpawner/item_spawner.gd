@tool
extends Node2D

class_name ItemSpawner

@export var item_scene: PackedScene:
	set(value):
		item_scene = value
		update_configuration_warnings()


func _get_configuration_warnings() -> PackedStringArray:
	var warnings = PackedStringArray()
	if item_scene == null:
		warnings.append("Es muss eine Item-Szene im Inspektor zugewiesen werden.")
	return warnings


func spawn_item(amount: int, rand_deviation: int = 0, radius: float = 30.0) -> void:
	if item_scene == null:
		push_error("Keine Item-Szene zugewiesen!")
		return

	var rand_amount = randi_range(amount - rand_deviation, amount + rand_deviation)

	if rand_amount > 0:
		for i in rand_amount:
			var instance = item_scene.instantiate()

			# Start- und Zielposition berechnen
			var start_pos = self.global_position
			var random_offset = Vector2.from_angle(randf() * TAU) * randf_range(radius / 2, radius)
			var target_pos = start_pos + random_offset

			# Item auf Startposition setzen und der Szene hinzufügen
			instance.global_position = start_pos
			get_tree().current_scene.call_deferred("add_child", instance)

			# Sprung-Parameter
			var jump_duration = 0.4
			var jump_height = 20.0 # Wie hoch das Item in die Luft fliegt

			# Tween für die X-Achse (lineare Bewegung zum Ziel)
			var tween_x = create_tween().bind_node(instance)
			tween_x.tween_property(instance, "global_position:x", target_pos.x, jump_duration)

			# Tween für die Y-Achse (hoch und dann runter)
			var tween_y = create_tween().bind_node(instance)
			# 1. Hälfte: Hoch in die Luft (Ease Out lässt es oben langsamer werden)
			tween_y.tween_property(instance, "global_position:y", start_pos.y - jump_height, jump_duration / 2.0) \
					.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
			# 2. Hälfte: Runter zum Ziel (Ease In lässt es nach unten schneller fallen)
			tween_y.tween_property(instance, "global_position:y", target_pos.y, jump_duration / 2.0) \
					.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
