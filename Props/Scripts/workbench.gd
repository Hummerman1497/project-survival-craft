class_name Workbench
extends Node2D

const WORKBENCH_UI = preload("uid://chmbiacidkerp")
const WORKBENCH_RECIPE_BUTTON = preload("uid://c55dban425dlu")

@export var workbench_inv_data: InventoryData

var recipes: Array[RecipeData]
var inter_container: PanelContainer
var workbench_open: bool
var new_workbench_ui: Control

@onready var interactable: Interactable = $Interactable
@onready var grid_45_100_px: Sprite2D = $"StaticBody2D/Grid45°100Px"


func _ready() -> void:
	workbench_open = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	interactable.focus_lost.connect(_focus_exited)
	inter_container = Inventory.interactable_container

	if workbench_inv_data:
		workbench_inv_data = workbench_inv_data.duplicate(true)


func interact() -> void:
	if workbench_open:
		_close_workbench()
	else:
		_open_workbench()


func _focus_exited() -> void:
	if workbench_open:
		_close_workbench()


func _close_workbench():
	workbench_open = false
	inter_container.visible = false
	inter_container.clear_inter_container()
	Inventory.inter_con_inv = null
	Inventory.inventory_open_close()
	print("[WB] closed now")


func _open_workbench():
	workbench_open = true
	recipes = Inventory.unlocked_recipes
	Inventory.inter_con_inv = workbench_inv_data
	inter_container.clear_inter_container()

	new_workbench_ui = WORKBENCH_UI.instantiate()
	inter_container.add_child(new_workbench_ui)

	new_workbench_ui.get_node("Chest_UI").inv_data = workbench_inv_data

	_update_recipe_ui_list()

	inter_container.visible = true

	if Inventory.inv_open != true:
		Inventory.inventory_open_close()
	print("[WB] open now")


func _update_recipe_ui_list():
	var new_recipe_list = new_workbench_ui.get_node("%Recipe_List")

	if not new_recipe_list:
		push_error("[WB] Node 'Recipe_List' wurde in new_workbench_ui nicht gefunden! Überprüfe den Pfad in der Szene.")
		return
	for child in new_recipe_list.get_children():
		child.queue_free()

	for recipe in recipes:
		var new_recipe_button = WORKBENCH_RECIPE_BUTTON.instantiate()
		new_recipe_list.add_child(new_recipe_button)
		var recipe_label = new_recipe_button.get_node("HBoxContainer/Label")
		var recipe_texture = new_recipe_button.get_node("HBoxContainer/TextureRect")
		recipe_label.text = recipe.recipe_name
		recipe_texture.texture = recipe.recipe_texture
