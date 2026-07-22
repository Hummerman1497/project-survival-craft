extends Node2D

const CHEST_UI = preload("uid://iocvt1802bs0")

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var chest_inv_data: InventoryData
@export var is_loot_chest: bool = false
@export var loot_table: Array[ItemData]
@export var loot_max: int = 10
@export var loot_min: int = 1


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	if chest_inv_data:
		chest_inv_data = chest_inv_data.duplicate(true)	
	if is_loot_chest:
		_fill_chest_with_loot()

func interact() -> void:
	var inter_container = Inventory.interactable_container
	var new_chest_ui = CHEST_UI.instantiate()
	new_chest_ui.inv_data = chest_inv_data
	inter_container.clear_inter_container()
	inter_container.add_child(new_chest_ui)
	Inventory.inventory_open_close()
	print(chest_inv_data.slots)
	
	if sprite_2d.visible == true:
		sprite_2d.visible = false
	else:
		sprite_2d.visible = true

func _fill_chest_with_loot():
	loot_table.shuffle()
	for s in loot_table:
		if s:
			var quantity = randi_range(loot_min,loot_max)
			chest_inv_data.add_item(s,quantity)
	
