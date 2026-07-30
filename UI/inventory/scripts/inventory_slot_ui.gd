class_name InventorySlotUI
extends Button

var slot_index: int
var slot_data: SlotData:
	set = set_slot_data
var _last_mouse_position: Vector2
var my_origin_inv: InventoryData

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label

@onready var popup_panel: PopupPanel = $PopupPanel
@onready var split_slider: HSlider = $PopupPanel/VBoxContainer/HSlider
@onready var percent_label: Label = $PopupPanel/VBoxContainer/Label
@onready var split_button: Button = $PopupPanel/VBoxContainer/Button


func _ready() -> void:
	texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	texture_rect.texture = null
	label.text = ""

	my_origin_inv = get_parent().inv_data

	split_slider.value_changed.connect(_on_slider_value_changed)
	split_button.pressed.connect(_on_confirm_split_pressed)

# Überschreibt die native Eingabefunktion des Buttons
var last_click_time: int = 0
var double_click_threshold: int = 400 # Zeit in Millisekunden


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			#Mausklick + Shift
			if event.shift_pressed:
				_on_slot_shift_clicked()
				accept_event()
				return

			var current_time = Time.get_ticks_msec()

			if current_time - last_click_time < double_click_threshold:
				# DOPPELKLICK ERKANNT!
				_on_slot_double_clicked()
				accept_event() # Blockiert alles andere
			else:
				# ERSTER KLICK
				last_click_time = current_time
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed and slot_data:
			_last_mouse_position = get_global_mouse_position()
			setup_popup_panel()


func _on_slot_shift_clicked() -> void:
	if slot_data == null:
		return
	var target_index: int
	var my_origin_inv_type = get_parent().inv_data.inv_type

	# Hotbar in Player Inventory
	#print("Origin Inventory: ", my_origin_inv_type, " | Index: ", slot_index)
	if my_origin_inv_type == "Player" and slot_index < Inventory.hot_bar_size and Inventory.inter_con_inv == null and Inventory.inv_open:
		target_index = get_first_free_slot(Inventory.player_inv_data, Inventory.hot_bar_size)
		if target_index != -1:
			my_origin_inv.drop_slot_data(my_origin_inv, slot_index, target_index)
		# Inventar ist voll -> abbruch
		else:
			return
	# Player Inv zu Hotbar wenn kein anderes Inv offen ist
	if my_origin_inv_type == "Player" and slot_index >= Inventory.hot_bar_size and Inventory.inter_con_inv == null and Inventory.inv_open:
		target_index = get_first_free_slot(Inventory.player_inv_data, 0, Inventory.hot_bar_size - 1)
		if target_index != -1:
			#print("Hotbar: ", target_index)
			my_origin_inv.drop_slot_data(my_origin_inv, slot_index, target_index)
		else:
			return

	# Player Inv zu Interactabel Inv
	if my_origin_inv_type == "Chest" and Inventory.inter_con_inv and Inventory.inv_open:
		target_index = get_first_free_slot(Inventory.player_inv_data, 0)
		if target_index >= 0:
			Inventory.player_inv_data.add_item(slot_data.item_data, slot_data.quantity)
			my_origin_inv.slots[slot_index] = null
			my_origin_inv.inventory_updated.emit()
		else:
			return

	# Interactable Ivn zu Player Inv
	if my_origin_inv_type == "Player" and Inventory.inter_con_inv and Inventory.inv_open:
		target_index = get_first_free_slot(Inventory.inter_con_inv, 0)
		if target_index != -1:
			Inventory.inter_con_inv.add_item(slot_data.item_data, slot_data.quantity)
			my_origin_inv.slots[slot_index] = null
			my_origin_inv.inventory_updated.emit()


func _on_slot_double_clicked() -> void:
	if slot_data == null:
		return
	var origin_inv = get_parent().inv_data

	if Inventory.player_inv_data.slots:
		_pull_items_from_inv(Inventory.player_inv_data, origin_inv)

	if Inventory.player_inv_data.slots and Inventory.inter_con_inv and Inventory.inter_con_inv.slots:
		_pull_items_from_inv(Inventory.inter_con_inv, origin_inv)


func _pull_items_from_inv(target_inv: InventoryData, origin_inv: InventoryData):
	var slots = target_inv.slots
	for e in range(slots.size()):
		var current_slot = slots[e]

		if current_slot == slot_data: #bei eigenem slot einfach ignorieren und weiter machen
			continue

		if current_slot and current_slot.item_data == slot_data.item_data:
			slot_data.quantity += current_slot.quantity
			slots[e] = null
			target_inv.inventory_updated.emit()
			if target_inv != origin_inv:
				origin_inv.inventory_updated.emit()


func set_slot_data(value: SlotData) -> void:
	slot_data = value
	if slot_data == null:
		# WICHTIG: Auf PASS stellen, damit Drag & Drop auf leeren Slots funktioniert!
		mouse_filter = Control.MOUSE_FILTER_PASS
		texture_rect.texture = null
		label.text = ""
		return

	mouse_filter = Control.MOUSE_FILTER_STOP
	texture_rect.texture = slot_data.item_data.texture
	label.text = str(slot_data.quantity)


# 1. Startet den Drag-Vorgang
func _get_drag_data(_at_position: Vector2) -> Variant: # wird im Quellen-Slot aufgerufen und übergibt daten die mit gedraged werden sollen
	if slot_data == null:
		return null # Leere Slots kann man nicht ziehen

	# Visuelle Vorschau an der Maus erstellen
	var preview_texture = TextureRect.new()
	preview_texture.texture = slot_data.item_data.texture
	preview_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	preview_texture.custom_minimum_size = Vector2(32, 32) # Passende Größe für dein Grid
	preview_texture.modulate.a = 0.8 # Leicht transparent machen

	# Damit die Vorschau mittig unter der Maus hängt
	var preview_control = Control.new()
	preview_control.add_child(preview_texture)
	preview_texture.position = -0.5 * preview_texture.custom_minimum_size
	preview_control.z_index = 100
	set_drag_preview(preview_control)

	# Wir übergeben den aktuellen Slot-Index als Daten
	return {
		"inventory": get_parent().inv_data, # Das Quell-Inventar
		"index": slot_index, # Der Quell-Index
	}


# 2. Prüft, ob man hier ablegen darf
func _can_drop_data(_at_position: Vector2, data: Variant) -> bool: # wird im potentiellen Ziel-slot (Mause hover drüber) bei jeder maus bewegung ausgeführt 
	# Akzeptieren, wenn die Daten eine Zahl (der Slot-Index) sind
	return typeof(data) == TYPE_DICTIONARY and data.has("inventory")


# 3. Führt das Ablegen / Tauschen / Stapeln aus
func _drop_data(_at_position: Vector2, data: Variant) -> void:
	# 1. Wir holen das Ziel-Inventar (wohin gedraggt wurde)
	var target_inventory = get_parent().inv_data
	var target_index = slot_index

	# 2. Wir lesen das Quell-Inventar und den Quell-Index aus den übergebenen Daten
	var origin_inventory = data["inventory"]
	var origin_index = data["index"]

	# 3. Wir rufen die neue drop_slot_data-Funktion auf, die das Stapeln übernimmt
	origin_inventory.drop_slot_data(target_inventory, origin_index, target_index)


func get_first_free_slot(inventory: InventoryData, start_index: int, end_index: int = 200) -> int:
	# range() geht von start_index bis end_index - 1
	for i in range(start_index, end_index):
		if inventory.slots[i] == null:
			return i
	return -1


func _on_slider_value_changed(value: float) -> void:
	percent_label.text = str(int(value))


func _on_confirm_split_pressed() -> void:
	my_origin_inv.split_item(slot_index, int(split_slider.value))
	popup_panel.hide()


func setup_popup_panel() -> void:
	if slot_data and slot_data.quantity > 1:
		split_slider.min_value = 1
		split_slider.max_value = slot_data.quantity - 1
		@warning_ignore("integer_division")
		split_slider.value = slot_data.quantity / 2
		@warning_ignore("integer_division")
		percent_label.text = str(slot_data.quantity / 2)
		popup_panel.popup(Rect2(_last_mouse_position, Vector2(80, 0)))
