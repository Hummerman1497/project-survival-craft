class_name ItemPickup
extends Node2D

@export var audio_pick_up: Array[AudioStream] = []
@export var item_data: ItemData:
	set = _set_item_data
@onready var pick_up_area: Area2D = $PickUpArea
var target: CharacterBody2D = null
var fly_speed: float = 150.0
@export var stats: Array = []
@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	_update_texture()
	pick_up_area.body_entered.connect(fly_to_player)


func fly_to_player(body):
	if body.is_in_group("player"):
		target = body


func _physics_process(delta: float) -> void:
	# Prüft, ob das Ziel gesetzt wurde UND noch im Spiel existiert
	if is_instance_valid(target):
		global_position = global_position.move_toward(target.global_position, fly_speed * delta)

		if global_position.distance_to(target.global_position) < 5.0:
			if item_data:
				if PlayerManager.INVENTORY_DATA.add_item(item_data) == true:
					item_picked_up()
			if target.has_method("pick_up_item"):
				target.pick_up_item(item_data, audio_pick_up)
			queue_free()


func item_picked_up():
	#print("[item_pickup] item picked up")
	pass


func _set_item_data(value: ItemData):
	_update_texture()
	item_data = value
	pass


func _update_texture() -> void:
	if item_data and sprite_2d:
		sprite_2d.texture = item_data.texture

	pass
