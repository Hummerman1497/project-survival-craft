extends Node2D

@onready var grid_45_100_px: Sprite2D = $"StaticBody2D/Grid45°100Px"


func _ready() -> void:
	pass


func interact() -> void:
	if grid_45_100_px.visible == true:
		grid_45_100_px.visible = false
	else:
		grid_45_100_px.visible = true
