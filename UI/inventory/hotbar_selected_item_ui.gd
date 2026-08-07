extends TextureRect

@onready var hotbar_ui: Hotbar_UI = $"../HotBarContainer/Hotbar_UI"

var hotbar_size: int:
	set(value):
		hotbar_size = value
		#TODO ggf. dynamische anpassung der hotbar beachten und dann auch selector anpassen

var hotbar_slots_location: Array[Vector2]
var cursor_selected_data: SlotData
var cursor_selected_index: int
var tween: Tween # Damit wird den bei überschreiben vorher stoppen können 


#TODO 1-9 als hotkey für hotbar slots
func _ready() -> void:
	Inventory.player_inv_data.inventory_updated.connect(updated_inv)
	if hotbar_ui:
		await get_tree().process_frame # damit die childs geordnet werden um die position zu wissen
		get_hb_slots_location()
		set_cursor(0)


func get_hb_slots_location() -> void:
	for i in hotbar_ui.get_children():
		var slot_global = i.global_position
		slot_global += Vector2(-5, -6)
		hotbar_slots_location.append(slot_global)


func set_cursor(slot_index: int) -> void:
	var new_cursor_location = hotbar_slots_location[slot_index]

	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", new_cursor_location, 0.1)

	cursor_selected_index = slot_index
	set_slot_data(cursor_selected_index)


func _unhandled_input(event: InputEvent) -> void:
	#MouseWheel
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			mousewheel_up()
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			mousewheel_down()
	#Hotkey
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode >= KEY_1 and event.keycode <= KEY_9:
			var slot_index = event.keycode - KEY_1
			if slot_index < Inventory.hot_bar_size:
				set_cursor(slot_index)


func mousewheel_up() -> void: # Cursor nach links
	var new_cursor_selected_index = cursor_selected_index - 1
	if new_cursor_selected_index < 0:
		new_cursor_selected_index = Inventory.hot_bar_size - 1
	set_cursor(new_cursor_selected_index)


func mousewheel_down() -> void: # Cursor nach rechts 
	var new_cursor_selected_index = cursor_selected_index + 1
	if new_cursor_selected_index >= Inventory.hot_bar_size:
		new_cursor_selected_index = 0
	set_cursor(new_cursor_selected_index)


func set_slot_data(index: int) -> void:
	var hotbar_slots = hotbar_ui.get_children()
	var slot_selected = hotbar_slots[index]
	if slot_selected.slot_data:
		if cursor_selected_data == slot_selected.slot_data:
			return
		cursor_selected_data = slot_selected.slot_data
		Inventory.hb_selected_slot = cursor_selected_data
	else:
		cursor_selected_data = null
		Inventory.hb_selected_slot = null


func updated_inv():
	set_slot_data(cursor_selected_index)
