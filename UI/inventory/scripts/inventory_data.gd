class_name InventoryData
extends Resource

signal inventory_updated # Signal für UI-Updates

@export var inv_type: String
@export var slots: Array[SlotData]

#TODO: 
# - stack sizes hinzufügen
# - dann erst checken wenn das item ranfliegen soll vom boden ob es überhaupt aufgenommen werden kann wenn nicht soll es garnicht zum player fliegen


func add_item(item: ItemData, count: int = 1) -> bool:
	for s in slots: # checks if item is already in inventory and adds it
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


func drop_slot_data(target_inv: InventoryData, origin_index: int, target_index: int) -> void:
	if self == target_inv and origin_index == target_index:
		return

	var slot_a = self.slots[origin_index]
	var slot_b = target_inv.slots[target_index]

	#Add item
	if slot_a != null and slot_b != null and slot_a.item_data == slot_b.item_data:
		slot_b.quantity += slot_a.quantity

		self.slots[origin_index] = null

		# Falls du eine max_stack_size in ItemData hast:
		# var max_stack = slot_b.item_data.max_stack_size
		# var space_left = max_stack - slot_b.quantity

		# Wenn Platz für alles ist:
		# if slot_a.quantity <= space_left:
		#     slot_b.quantity += slot_a.quantity
		#     self.slots[origin_index] = null
		# Wenn nur ein Teil reinpasst:
		# else:
		#     slot_b.quantity += space_left
		#     slot_a.quantity -= space_left
	#Swapp item
	else:
		self.slots[origin_index] = slot_b
		target_inv.slots[target_index] = slot_a

	# Signale senden, um die UI zu aktualisieren
	self.inventory_updated.emit()
	if self != target_inv:
		target_inv.inventory_updated.emit()


func split_item(origin_index: int, splited_quantity: int) -> void:
	var current_item = slots[origin_index]
	if not current_item or current_item.quantity <= 1:
		return

	var target_index = find_closest_free_slot(origin_index)
	if target_index == -1:
		return # Inventar voll, Abbruch

	var splited_item = current_item.duplicate()
	splited_item.quantity = splited_quantity

	slots[target_index] = splited_item
	slots[origin_index].quantity -= splited_quantity
	inventory_updated.emit()


func find_closest_free_slot(origin_index: int) -> int:
	var max_distance = max(origin_index, slots.size() - 1 - origin_index)

	for distance in range(1, max_distance + 1):
		var right = origin_index + distance
		if right < slots.size() and slots[right] == null:
			return right

		var left = origin_index - distance
		if left >= 0 and slots[left] == null:
			return left

	return -1
