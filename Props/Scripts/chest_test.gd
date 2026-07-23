extends Node2D

const CHEST_UI = preload("uid://iocvt1802bs0")

@onready var sprite_closed: Sprite2D = $Sprite_closed
@onready var sprite_open: Sprite2D = $Sprite_open
@onready var interactable: Interactable = $Interactable


@export var chest_inv_data: InventoryData
@export var is_loot_chest: bool = false
@export var loot_table: Array[ItemData]
@export var loot_max: int = 10
@export var loot_min: int = 1


var chest_open: bool = false
var inter_container: PanelContainer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	interactable.focus_exited.connect(_focus_exited)
	inter_container = Inventory.interactable_container
	if chest_inv_data:
		chest_inv_data = chest_inv_data.duplicate(true)	
	if is_loot_chest:
		_fill_chest_with_loot()
		
	sprite_closed.visible = true
	sprite_open.visible = false

func interact() -> void:	
	if chest_open: 
		_close_chest()
	else:
		_open_chest()
	
	
func _fill_chest_with_loot():
	for s in loot_table:
		if s:
			var quantity = randi_range(loot_min,loot_max)
			chest_inv_data.add_item(s,quantity)
	chest_inv_data.slots.shuffle()


func _focus_exited() -> void:
	if chest_open:
		_close_chest()
	

func _close_chest() -> void:	
	sprite_closed.visible = true
	sprite_open.visible = false
	inter_container.clear_inter_container()
	Inventory.inter_con_inv = null
	inter_container.visible = false
	chest_open = false
	Inventory.inventory_open_close()
	
func _open_chest()-> void:
	sprite_closed.visible = false
	sprite_open.visible = true
	inter_container.clear_inter_container()
	var new_chest_ui = CHEST_UI.instantiate()
	new_chest_ui.inv_data = chest_inv_data
	Inventory.inter_con_inv = chest_inv_data
	inter_container.add_child(new_chest_ui)
	inter_container.visible = true
	chest_open = true
	if Inventory.inv_open != true:
		Inventory.inventory_open_close()
