class_name Rock
extends Node2D

@export var health: int = 1
@export var resource_drop: int = 3

@onready var hit_box: HitBox = $HitBox
@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready():
	$HitBox.damaged.connect(take_damage)


func take_damage(hurt_box: HurtBox) -> void:
	health -= hurt_box.damage

	if health >= 1:
		hit_box.play_shake(sprite_2d)
	else:
		queue_free()
		$ItemSpawner.spawn_item(3)
