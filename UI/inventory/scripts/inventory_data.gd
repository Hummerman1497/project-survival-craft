class_name InventoryData
extends Resource

signal inventory_updated # Signal für UI-Updates

@export var slots: Array[SlotData]


func add_item(item: ItemData, count: int = 1) -> bool:
	for s in slots: # checks if item is already in invetory and adds it
		if s:
			if s.item_data == item:
				s.quantity += count
				inventory_updated.emit()
				return true

	for i in slots.size():
		if slots[i] == null:
			var new_item = SlotData.new()
			new_item.item_data = item
			new_item.quantity = count
			slots[i] = new_item
			inventory_updated.emit()
			return true
	print("[InvData] Inventory was full")
	return false


func swap_slots(index_a: int, index_b: int) -> void:
	# Wenn man ein Item auf den eigenen Slot fallen lässt, nichts tun
	if index_a == index_b:
		return

	# WICHTIG: Tauschen mit Zwischenspeicher, damit nichts überschrieben/verdoppelt wird!
	var temp = slots[index_a]
	slots[index_a] = slots[index_b]
	slots[index_b] = temp

	# Signal an die UI senden, dass sich die Daten geändert haben
	inventory_updated.emit()
