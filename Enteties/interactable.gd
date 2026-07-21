class_name Interactable
extends Node2D

@onready var area_2d: Area2D = $Area2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
@export var collision_radius: int
var is_target = false


func _ready() -> void:
	PlayerManager.interact_pressed.connect(interact) # wird in walk & idle emitted bei key "interact"
	PlayerManager.interactable_target.connect(_set_interactable)


func interact():
	if is_target:
		print("[Interactable] mit mir wurde E gedrückt: ", self.get_parent().name)
		var parent = self.get_parent()
		if parent.has_method("interact"):
			parent.interact()


func _set_interactable(target):
	if target == self:
		if not is_target:
			is_target = true
			print("[Interactable] Fokus erhalten: ", self.get_parent().name)
	else:
		if is_target: # Verhindert Ausführung bei Objekten, die den Fokus ohnehin nicht hatten
			is_target = false
			print("[Interactable] Fokus verloren: ", self.get_parent().name)
