class_name InventoryUI
extends Node

const INVENTROY_SLOT = preload("uid://cgr0juhq374uj")
@export var data: InventoryData


func _ready() -> void:
	Inventory.shown.connect(update_inventory)
	Inventory.hidden.connect(clear_inventory)

	if data:
		data.inventory_updated.connect(update_inventory)

	# Am Anfang einmal leeren, um sicherzugehen
	clear_inventory()


func clear_inventory() -> void:
	for c in get_children():
		c.queue_free()


func update_inventory() -> void:
	if not data:
		return

	var existing_slots = get_children()

	# Fall 1: Wir haben noch keine Slots im UI -> Einmalig erstellen!
	if existing_slots.size() != data.slots.size():
		clear_inventory()
		for s in data.slots:
			var new_slot = INVENTROY_SLOT.instantiate()
			add_child(new_slot)
			new_slot.slot_data = s

	# Fall 2: Slots existieren bereits -> Nur die Daten aktualisieren! (Perfekt für Drag & Drop)
	else:
		for i in data.slots.size():
			existing_slots[i].slot_data = data.slots[i]
