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

func swap_inventory(inv_a: InventoryData, inv_b: InventoryData, index_a: int, index_b: int) -> void:
	# 1. Abbruch, wenn es exakt derselbe Slot im selben Inventar ist
	if inv_a == inv_b and index_a == index_b:
		return

	# 2. Wir holen uns die beiden Slots über die Parameter (nicht über 'slots')
	var slot_a = inv_a.slots[index_a]
	var slot_b = inv_b.slots[index_b]

	# 3. Tauschen ausführen
	inv_a.slots[index_a] = slot_b
	inv_b.slots[index_b] = slot_a

	# 4. BEIDE Inventare müssen ihre UI benachrichtigen!
	inv_a.inventory_updated.emit()
	
	# Nur emitten, wenn es wirklich zwei verschiedene Inventar-Ressourcen sind
	if inv_a != inv_b:
		inv_b.inventory_updated.emit()


func swap_with(target_inv: InventoryData, origin_index: int, target_index: int) -> void:
	var slot_a = self.slots[origin_index]
	var slot_b = target_inv.slots[target_index]

	self.slots[origin_index] = slot_b
	target_inv.slots[target_index] = slot_a

	self.inventory_updated.emit()
	if self != target_inv:
		target_inv.inventory_updated.emit()
