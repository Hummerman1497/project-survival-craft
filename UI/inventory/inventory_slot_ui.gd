class_name InventorySlotUI
extends Button

var slot_index: int 
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
	"index": slot_index                 # Der Quell-Index
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
