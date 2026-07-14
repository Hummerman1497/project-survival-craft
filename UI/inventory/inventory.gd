extends CanvasLayer

signal shown
signal hidden
var inv_open: bool = false
@export var hot_bar_size: int = 6
@onready var inv_panel_container: PanelContainer = $Inv_Panel_Container


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide_inventory()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		if inv_open:
			hide_inventory()
		else:
			show_inventory()
		get_viewport().set_input_as_handled()


func show_inventory() -> void:
	get_tree().paused = true #nimmt den ganzen tree und pausiert ihn
	inv_panel_container.visible = true
	inv_open = true
	shown.emit()


func hide_inventory() -> void:
	get_tree().paused = false #nimmt den ganzen tree und resumed ihn
	inv_panel_container.visible = false
	inv_open = false
	hidden.emit()
