class_name InventorySlotUI
extends Button

var slot_index: int = -1
var slot_data: SlotData:
	set = set_slot_data

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label


func _ready() -> void:
	texture_rect.texture = null
	label.text = ""


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
func _get_drag_data(at_position: Vector2) -> Variant:
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
	return slot_index


# 2. Prüft, ob man hier ablegen darf
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	# Akzeptieren, wenn die Daten eine Zahl (der Slot-Index) sind
	return typeof(data) == TYPE_INT


# 3. Führt das Ablegen / Tauschen aus
func _drop_data(at_position: Vector2, data: Variant) -> void:
	var origin_index = data as int
	var target_index = slot_index

	if origin_index == target_index:
		return

	# Holen der InventoryData über den Parent (GridContainer -> Panel -> UI)
	# Alternativ: Wenn dein UI die Daten hält, suchen wir den InventoryUI Node
	var inventory_ui = get_parent()
	if inventory_ui and inventory_ui.inv_data:
		inventory_ui.inv_data.swap_slots(origin_index, target_index)
