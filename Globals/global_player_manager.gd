extends Node

const INVENTORY_DATA: InventoryData = preload("uid://cvfs2km3nf11b")

signal interact_pressed
signal interactable_target(target)

var player: Player
