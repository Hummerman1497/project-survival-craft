extends Node2D

const CHEST_UI = preload("uid://iocvt1802bs0")

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var chest_inv_data: InventoryData
@export var is_loot_chest: bool = false
@export var loot_table: Array[ItemData]
@export var loot_max: int = 10
@export var loot_min: int = 1

var chest_open: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	if chest_inv_data:
		chest_inv_data = chest_inv_data.duplicate(true)	
	if is_loot_chest:
		_fill_chest_with_loot()

func interact() -> void:
	var inter_container = Inventory.interactable_container
	
	if chest_open:
		inter_container.clear_inter_container()
		inter_container.visible = false
		chest_open = false
		Inventory.inventory_open_close()
	else:
		inter_container.clear_inter_container()
		var new_chest_ui = CHEST_UI.instantiate()
		new_chest_ui.inv_data = chest_inv_data
		inter_container.add_child(new_chest_ui)
		inter_container.visible = true
		chest_open = true
		Inventory.inventory_open_close()
	
	
	
func _fill_chest_with_loot():
	for s in loot_table:
		if s:
			var quantity = randi_range(loot_min,loot_max)
			chest_inv_data.add_item(s,quantity)
	chest_inv_data.slots.shuffle()
