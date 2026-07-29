extends Button

const INVENTORY_SLOT = preload("uid://cgr0juhq374uj")

@onready var texture_rect: TextureRect = $HBoxContainer/TextureRect
@onready var label: Label = $HBoxContainer/Label
@onready var texture_description: TextureRect = $"../../../PanelContainer/Details/MarginContainer/TextureRect"
@onready var rich_text_label: RichTextLabel = $"../../../PanelContainer/Details/RichTextLabel"
@onready var label_description: Label = $"../../../PanelContainer/Details/Name"
@onready var requirements_slots: HBoxContainer = $"../../../PanelContainer/Details/Requirements_Slots"

var rich_description: String
var recipe: RecipeData


func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	button_down.connect(_on_button_down)


func _on_mouse_entered():
	for i in requirements_slots.get_children():
		i.queue_free()
	texture_description.texture = texture_rect.texture
	label_description.text = label.text
	rich_text_label.text = rich_description
	for slot in recipe.input:
		var has_item = false
		for i in Inventory.inter_con_inv.slots:
			if i and i.item_data.name == slot.item_data.name:
				if i.quantity >= slot.quantity:
					has_item = true
		for i in Inventory.player_inv_data.slots:
			if i and i.item_data.name == slot.item_data.name:
				if i.quantity >= slot.quantity:
					has_item = true

		var new_slot = INVENTORY_SLOT.instantiate()
		var new_margin_container = MarginContainer.new()
		requirements_slots.add_child(new_margin_container)
		new_margin_container.size_flags_horizontal = 3
		new_margin_container.add_child(new_slot)
		new_slot.label.text = str(slot.quantity)
		new_slot.texture_rect.texture = slot.item_data.texture
		new_slot.disabled = true #disabled hover function
		if not has_item:
			new_slot.texture_rect.modulate.a = 0.3
			new_slot.label.modulate.a = 0.3


func _on_button_down():
	pass
