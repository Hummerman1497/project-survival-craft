extends Node2D

var mouse_position : Vector2 = Vector2.ZERO

func _process(_delta: float) -> void:
	# Schritt 1: Vektor vom Spieler zur Maus berechnen und normalisieren
	mouse_position = get_global_mouse_position()
	var direction_to_mouse: Vector2 = (mouse_position - global_position).normalized()
	
	# Schritt 2: Winkel im Bogenmaß (Radiant) holen
	var angle: float = direction_to_mouse.angle()
	
	# Den eingerasteten Winkel zurück in einen sauberen Richtungs-Vektor umwandeln
	rotation = angle
	
	
	
