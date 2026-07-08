class_name InventoryUI
extends Node

const INVENTROY_SLOT = preload("uid://cgr0juhq374uj")
@export var data: InventoryData


func _ready() -> void:
	Inventory.shown.connect(update_inventory)
	Inventory.hidden.connect(clear_inventory)
	clear_inventory()
	pass


func clear_inventory() -> void:
	for c in get_children():
		c.queue_free()


func update_inventory() -> void:
	for s in data.slots:
		var new_slot = INVENTROY_SLOT.instantiate()
		add_child(new_slot)
		new_slot.slot_data = s
