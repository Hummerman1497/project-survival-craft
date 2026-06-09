class_name State extends Node

## Stores a reference to the player that this State belongs to
static var player: Player


## What happens when the Player enters this State?
func Enter() -> void:
	pass


## What happens when the Player exits this State?
func Exit() -> void:
	pass


## What happens during the _process update in this State ?
func Process(_delta : float) -> State:
	return null


## What happens during the _physics_process update in this State ?
func Physics(_delta : float) -> State:
	return null


## What happens with the input events in this State?	
func HandleInput(_event: InputEvent) -> State:
	return null
