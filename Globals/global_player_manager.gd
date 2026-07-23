extends Node

const INVENTORY_DATA: InventoryData = preload("uid://cvfs2km3nf11b")

@warning_ignore("unused_signal")
signal interact_pressed
@warning_ignore("unused_signal")
signal interactable_target(target)

var player: Player
