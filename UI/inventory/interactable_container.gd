extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func clear_inter_container() -> void:
	for c in get_children():
		c.queue_free()
		
func add_inter_ui(ui_scene):
	if is_instance_valid(ui_scene):
		var new_ui = ui_scene.instantiate()
		add_child(new_ui)
