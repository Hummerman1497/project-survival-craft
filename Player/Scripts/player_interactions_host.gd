class_name PlayerInteractionsHost extends Node2D

@onready var player: Player = $".."

func _ready():
	player.DirectionChanged.connect(UpdateDirection)
	player.AngleToMouse.connect(UpdateAngle)

#Interactions zeigt in die 45° Directions richtung 
func UpdateDirection( new_direction : Vector2) -> void:
	match new_direction:
		Vector2.DOWN:
			rotation_degrees = 0
		Vector2.UP:
			rotation_degrees = 180
		Vector2.LEFT:
			rotation_degrees = 90		
		Vector2.RIGHT:
			rotation_degrees = -90	
		Vector2(-1,-1):			
			rotation_degrees = 135
		Vector2(1,1):
			rotation_degrees = -45			
		Vector2(1,-1):
			rotation_degrees = -135
		Vector2(-1,1):
			rotation_degrees = 45
		_:
			rotation_degrees = 0

#Interaction (bzw. Hurtbox) zeigt in die Mausrichtung
func UpdateAngle(angle:float) -> void:	
	rotation = angle - PI/2
