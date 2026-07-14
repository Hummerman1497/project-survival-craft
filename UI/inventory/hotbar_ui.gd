@tool
class_name Hotbar_UI
extends Node

const INVENTROY_SLOT = preload("uid://cgr0juhq374uj") #Button der die SlotData visualisiert, mit Texture und Label

@export var inv_data: InventoryData:
	set(value):
		inv_data = value
		update_configuration_warnings() # Aktualisiert die Warnung im Editor sofort bei Zuweisung


func _get_configuration_warnings() -> PackedStringArray:
	var warnings = PackedStringArray()
	if not inv_data:
		warnings.append("Die Variable 'inv_data' (InventoryData) wurde im Inspector nicht zugewiesen!")
	return warnings


func _ready() -> void:
	#connected auf picked up item so das sich die hotbar jedes mal updated wenn was aufgenommen wird
	self.columns = Inventory.hot_bar_size
	if inv_data:
		inv_data.inventory_updated.connect(update_hotbar)
	update_hotbar()


func clear_hotbar() -> void:
	for c in get_children():
		c.queue_free()


func update_hotbar() -> void:
	if not inv_data:
		return

	var existing_slots = get_children()
	# 1. Initialize Slots
	if existing_slots.size() != Inventory.hot_bar_size:
		clear_hotbar()
		for i in Inventory.hot_bar_size:
			var new_slot = INVENTROY_SLOT.instantiate()
			add_child(new_slot)
			new_slot.slot_index = i
			new_slot.slot_data = inv_data.slots[i]
	# 2. Update		
	else:
		for i in Inventory.hot_bar_size:
			existing_slots[i].slot_index = i
			existing_slots[i].slot_data = inv_data.slots[i]
