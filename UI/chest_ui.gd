@tool
class_name ChestUI
extends Node

const INVENTORY_SLOT = preload("uid://cgr0juhq374uj") #Button der die SlotData visualisiert, mit Texture und Label

var inv_data: InventoryData #wird von der Chest gesetzt in _ready()
	
func _ready() -> void:
	if Engine.is_editor_hint():
		return
	Inventory.shown.connect(update_inventory)
	Inventory.hidden.connect(clear_inventory)

	if inv_data:
		inv_data.inventory_updated.connect(update_inventory)

	# Am Anfang einmal leeren, um sicherzugehen
	clear_inventory()
	
	if inv_data:
		update_inventory()


func clear_inventory() -> void:
	for c in get_children():
		c.queue_free()


func update_inventory() -> void:
	if not inv_data:
		return

	var existing_slots = get_children()

	if existing_slots.size() != inv_data.slots.size() - Inventory.hot_bar_size:
		clear_inventory()
		# Fall 1: Neu erstellen, aber über range iterieren um 'i' zu haben
		for i in inv_data.slots.size():
			var new_slot = INVENTORY_SLOT.instantiate()
			add_child(new_slot)
			new_slot.slot_index = i # <-- NEU: Echten Index übergeben
			new_slot.slot_data = inv_data.slots[i]

	else:
		# Fall 2: Updaten
		for i in inv_data.slots.size():
			var ui_slot = existing_slots[i - Inventory.hot_bar_size]
			ui_slot.slot_index = i # <-- NEU: Index sicherheitshalber setzen
			ui_slot.slot_data = inv_data.slots[i]
