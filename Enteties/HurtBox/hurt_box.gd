class_name HurtBox
extends Area2D

signal hurtbox_hit(hitbox: HitBox)
@export var damage: int = 1


func _ready():
	area_entered.connect(AreaEntered)


func AreaEntered(area: Area2D) -> void:
	if area is HitBox:
		area.take_damage(damage)
		hurtbox_hit.emit(area)
