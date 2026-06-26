extends Node2D

@export var audio_pick_up: Array[AudioStream] = []

@onready var pick_up_area: Area2D = $PickUpArea
var target: CharacterBody2D = null
var fly_speed: float = 150.0
var stats: Array = ["Holz", "1 Item"]

func _ready() -> void:
	pick_up_area.body_entered.connect(fly_to_player)
	
func fly_to_player(body):
	if body.is_in_group("player"):
		target = body
	
func _physics_process(delta: float) -> void:
	# Prüft, ob das Ziel gesetzt wurde UND noch im Spiel existiert
	if is_instance_valid(target):
		global_position = global_position.move_toward(target.global_position, fly_speed * delta)
		
		if global_position.distance_to(target.global_position) < 5.0:
			if target.has_method("pick_up_item"):
				target.pick_up_item(stats, audio_pick_up)
			queue_free()
