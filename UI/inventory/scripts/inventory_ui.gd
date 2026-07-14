@tool
class_name InventoryUI
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
	Inventory.shown.connect(update_inventory)
	Inventory.hidden.connect(clear_inventory)

	if inv_data:
		inv_data.inventory_updated.connect(update_inventory)

	# Am Anfang einmal leeren, um sicherzugehen
	clear_inventory()


func clear_inventory() -> void:
	for c in get_children():
		c.queue_free()


func update_inventory() -> void:
	if not inv_data:
		return

	var existing_slots = get_children() # Alle InvetorySlot_Ui [Button] die angehängt sind

	# Fall 1: Wir haben noch keine Slots im UI -> Einmalig erstellen!
	if existing_slots.size() != inv_data.slots.size(): # Wenn das Array mit den SlotData nicht gleich dem existierenden Inv ist:
		clear_inventory()
		for s in inv_data.slots: # inv_data.slots Array[SlotData]
			var new_slot = INVENTROY_SLOT.instantiate() # Button mit SlotData, Texture und Label
			add_child(new_slot)
			new_slot.slot_data = s

	# Fall 2: Slots existieren bereits -> Nur die Daten aktualisieren! (Perfekt für Drag & Drop)
	else:
		for i in inv_data.slots.size():
			existing_slots[i].slot_data = inv_data.slots[i]
