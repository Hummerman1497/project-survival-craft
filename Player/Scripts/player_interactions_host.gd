class_name PlayerInteractionsHost
extends Node2D

@onready var player: Player = $".."
@onready var interact_detect: Area2D = $InteractDetect
var interactables: Array
var current_target: Node2D = null


func _ready():
	player.DirectionChanged.connect(UpdateDirection)
	player.AngleToMouse.connect(UpdateAngle)
	interact_detect.area_entered.connect(_on_area_entered)
	interact_detect.area_exited.connect(_on_area_exited)


func _process(_delta: float) -> void:
	if interactables.is_empty():
		if current_target != null:
			PlayerManager.interactable_target.emit(null) # Niemand mehr im Fokus
			current_target = null
		return

	interactables.sort_custom(_sort_by_distance)
	var new_target = interactables[0]
	if new_target != current_target:
		current_target = new_target
		var parent = current_target.get_parent()
		PlayerManager.interactable_target.emit(parent)


#Interactions zeigt in die 45° Directions richtung 
func UpdateDirection(new_direction: Vector2) -> void:
	match new_direction:
		Vector2.DOWN:
			rotation_degrees = 0
		Vector2.UP:
			rotation_degrees = 180
		Vector2.LEFT:
			rotation_degrees = 90
		Vector2.RIGHT:
			rotation_degrees = -90
		Vector2(-1, -1):
			rotation_degrees = 135
		Vector2(1, 1):
			rotation_degrees = -45
		Vector2(1, -1):
			rotation_degrees = -135
		Vector2(-1, 1):
			rotation_degrees = 45
		_:
			rotation_degrees = 0


#Interaction (bzw. Hurtbox) zeigt in die Mausrichtung
func UpdateAngle(angle: float) -> void:
	rotation = angle - PI / 2


func _on_area_entered(area):
	var parent = area.get_parent()
	if parent is Interactable:
		interactables.append(area)


func _on_area_exited(area):
	if area in interactables:
		interactables.erase(area)


func _sort_by_distance(a: Node2D, b: Node2D) -> bool:
	var dist_a = global_position.distance_squared_to(a.global_position)
	var dist_b = global_position.distance_squared_to(b.global_position)
	return dist_a < dist_b
