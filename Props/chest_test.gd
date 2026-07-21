extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D


func interact() -> void:
	if sprite_2d.visible == true:
		sprite_2d.visible = false
	else:
		sprite_2d.visible = true
