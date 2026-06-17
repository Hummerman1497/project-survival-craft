extends Node2D

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_debug"):
		toggle_2d_collisions()
		

func toggle_2d_collisions():
	var tree = get_tree()
	tree.debug_collisions_hint = not tree.debug_collisions_hint
	
	# Rekursiver Durchlauf aller Nodes im aktuellen Spielbaum
	var stack = [tree.root]
	while not stack.is_empty():
		var current_node = stack.pop_back()
		
		if is_instance_valid(current_node):
			if current_node is CollisionShape2D or current_node is CollisionPolygon2D:
				# Trigger für den CanvasItem- / Physik-Server, die Debug-Form neu zu zeichnen:
				var parent = current_node.get_parent()
				if parent:
					parent.remove_child(current_node)
					parent.add_child(current_node)
			
			# Kinder für den nächsten Durchlauf hinzufügen
			stack.append_array(current_node.get_children())
