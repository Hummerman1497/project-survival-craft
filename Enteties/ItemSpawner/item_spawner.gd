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

func spawn_item(amount: int, radius: float = 50.0) -> void:
	if item_scene == null:
		push_error("Keine Item-Szene zugewiesen!")
		return
		
	for i in amount:
		var instance = item_scene.instantiate()
		
		var random_offset = Vector2.from_angle(randf() * TAU) * randf_range(0, radius)
		instance.global_position = self.global_position + random_offset
		
		get_tree().current_scene.call_deferred("add_child", instance)
