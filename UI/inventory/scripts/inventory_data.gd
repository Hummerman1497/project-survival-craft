class_name InventoryData
extends Resource

@export var slots: Array[SlotData]


func add_item(item: ItemData, count: int = 1) -> bool:
	for s in slots: # checks if item is already in invetory and adds it
		if s:
			if s.item_data == item:
				s.quantity += count
				return true

	for i in slots.size():
		if slots[i] == null:
			var new_item = SlotData.new()
			new_item.item_data = item
			new_item.quantity = count
			slots[i] = new_item
			return true
	print("[InvData] Inventory was full")
	return false
