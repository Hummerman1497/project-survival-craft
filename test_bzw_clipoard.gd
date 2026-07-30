@onready var split_popup: PopupPanel = $SplitPopup
@onready var split_slider: HSlider = $SplitPopup/VBoxContainer/SplitSlider
@onready var percent_label: Label = $SplitPopup/VBoxContainer/PercentLabel
@onready var confirm_button: Button = $SplitPopup/VBoxContainer/ConfirmButton


func _ready() -> void:
	texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	texture_rect.texture = null
	label.text = ""

	my_origin_inv = get_parent().inv_data

	# Slider Setup
	split_slider.min_value = 1
	split_slider.max_value = 100
	split_slider.value = 50
	percent_label.text = "50 %"

	# Signale verbinden
	split_slider.value_changed.connect(_on_slider_value_changed)
	confirm_button.pressed.connect(_on_confirm_split_pressed)


func _gui_input(event: InputEvent) -> void:
	# ... (dein bisheriger Code für Links- und Shift-Klick bleibt gleich) ...

	if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed and slot_data:
		_last_mouse_position = get_global_mouse_position()
		# Slider vor dem Öffnen immer wieder auf 50 setzen
		split_slider.value = 50
		split_popup.popup(Rect2(_last_mouse_position, Vector2(150, 80))) # Größe je nach Bedarf anpassen


# Aktualisiert den Text beim Bewegen des Sliders
func _on_slider_value_changed(value: float) -> void:
	percent_label.text = str(value) + " %"


# Führt den Split aus, wenn der Button geklickt wird
func _on_confirm_split_pressed() -> void:
	var split_percent = split_slider.value
	print("Item ", slot_data.item_data.name, " wird zu ", split_percent, "% gesplittet.")

	# Du musst deine my_origin_inv.split_item Funktion so anpassen, 
	# dass sie die Prozentzahl als zweites Argument annimmt!
	my_origin_inv.split_item(slot_index, split_percent)

	split_popup.hide()
