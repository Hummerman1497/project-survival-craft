extends Button

const INVENTORY_SLOT = preload("uid://cgr0juhq374uj")
const WORKBENCH_OPEN_CLOSE = preload("uid://cn7iyq8pg0yr8")

@onready var texture_rect: TextureRect = $HBoxContainer/TextureRect
@onready var label: Label = $HBoxContainer/Label
@onready var texture_description: TextureRect = $"../../../PanelContainer/Details/MarginContainer/TextureRect"
@onready var rich_text_label: RichTextLabel = $"../../../PanelContainer/Details/RichTextLabel"
@onready var label_description: Label = $"../../../PanelContainer/Details/Name"
@onready var requirements_slots: HBoxContainer = $"../../../PanelContainer/Details/Requirements_Slots"

var rich_description: String
var recipe: RecipeData: #wird in Workench.gd gesetzt
	set(value):
		recipe = value
		_update_transparency()


func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	button_down.connect(_on_button_down)
	Inventory.player_inv_data.inventory_updated.connect(_update_transparency)
	Inventory.inter_con_inv.inventory_updated.connect(_update_transparency)


func _update_transparency() -> void:
	if not recipe:
		return

	if not can_craft():
		texture_rect.modulate.a = 0.3
		disabled = true
	else:
		texture_rect.modulate.a = 1.0 # Falls es später wieder craftbar wird
		disabled = false


func get_item_count(item_name: String) -> int:
	var count = 0

	for i in Inventory.inter_con_inv.slots:
		if i and i.item_data.name == item_name:
			count += i.quantity

	for i in Inventory.player_inv_data.slots:
		if i and i.item_data.name == item_name:
			count += i.quantity

	return count


func can_craft() -> bool:
	for slot in recipe.input:
		if get_item_count(slot.item_data.name) < slot.quantity:
			return false
	return true


func set_requirements_visuals():
	for i in requirements_slots.get_children():
		i.queue_free()
	texture_description.texture = texture_rect.texture
	label_description.text = label.text
	rich_text_label.text = rich_description

	for slot in recipe.input:
		var has_item = get_item_count(slot.item_data.name) >= slot.quantity

		var new_slot = INVENTORY_SLOT.instantiate()
		var new_margin_container = CenterContainer.new()
		requirements_slots.add_child(new_margin_container)
		new_margin_container.size_flags_horizontal = 3
		new_margin_container.add_child(new_slot)
		new_slot.label.text = str(slot.quantity)
		new_slot.texture_rect.texture = slot.item_data.texture
		new_slot.disabled = true #disabled hover function

		if not has_item:
			new_slot.texture_rect.modulate.a = 0.3
			new_slot.label.modulate.a = 0.3


func _on_mouse_entered():
	set_requirements_visuals()


func _on_button_down():
	if can_craft():
		_remove_requiret_items_from_inventory()
		for output in recipe.output:
			Inventory.inter_con_inv.add_item(output.item_data, output.quantity)
			PlayerManager.player.audio_player.stream = WORKBENCH_OPEN_CLOSE
			PlayerManager.player.audio_player.play()


func _remove_requiret_items_from_inventory():
	for slot in recipe.input:
		var remaining_to_remove = slot.quantity

		# 1.Workbench Inventory 
		for i in Inventory.inter_con_inv.slots:
			if remaining_to_remove <= 0:
				break
			if i and i.item_data.name == slot.item_data.name:
				var take_amount = min(remaining_to_remove, i.quantity)
				i.quantity -= take_amount
				remaining_to_remove -= take_amount

				if i.quantity <= 0:
					var index = Inventory.inter_con_inv.slots.find(i)
					Inventory.inter_con_inv.slots[index] = null
		# 2. Player Inventory
		for i in Inventory.player_inv_data.slots:
			if remaining_to_remove <= 0:
				break
			if i and i.item_data.name == slot.item_data.name:
				var take_amount = min(remaining_to_remove, i.quantity)
				i.quantity -= take_amount
				remaining_to_remove -= take_amount

				if i.quantity <= 0:
					var index = Inventory.player_inv_data.slots.find(i)
					Inventory.player_inv_data.slots[index] = null

	Inventory.player_inv_data.inventory_updated.emit()
	Inventory.inter_con_inv.inventory_updated.emit()
	set_requirements_visuals()
