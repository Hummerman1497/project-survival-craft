class_name Interactable
extends Node2D

signal focus_entered
signal focus_lost

@onready var area_2d: Area2D = $Area2D
@onready var texture_rect: TextureRect = $TextureRect
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
var is_target = false

# CollisionShape2D Uniq machen wenn man einen andere raidus haben will !!!


func _ready() -> void:
	PlayerManager.interact_pressed.connect(interact) # wird in walk & idle emitted bei key "interact"
	PlayerManager.interactable_target.connect(_set_interactable)
	texture_rect.visible = false


func interact():
	if is_target:
		#print("[Interactable] mit mir wurde E gedrückt: ", self.get_parent().name)
		var parent = self.get_parent()
		if parent.has_method("interact"):
			parent.interact()


func _set_interactable(target):
	if target == self:
		if not is_target:
			is_target = true
			texture_rect.visible = true
			#print("[Interactable] Fokus erhalten: ", self.get_parent().name)
			focus_entered.emit()
	else:
		if is_target: # Verhindert Ausführung bei Objekten, die den Fokus ohnehin nicht hatten
			is_target = false
			texture_rect.visible = false
			#print("[Interactable] Fokus verloren: ", self.get_parent().name)
			focus_lost.emit()
