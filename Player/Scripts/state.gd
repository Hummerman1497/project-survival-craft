class_name State
extends Node

@warning_ignore("unused_signal")
signal cooldown_finished
signal cooldown_started
## Stores a reference to the player that this State belongs to
static var player: Player
@export var cooldown: float = 0.00
var cooldown_timer: float = 0.0


## What happens when the Player enters this State?
func Enter() -> void:
	pass


## What happens when the Player exits this State?
func Exit() -> void:
	pass


## What happens during the _process update in this State ?
func Process(_delta: float) -> State:
	return null


## What happens during the _physics_process update in this State ?
func Physics(_delta: float) -> State:
	return null


## What happens with the input events in this State?	
func HandleInput(_event: InputEvent) -> State:
	return null


func is_on_cooldown() -> bool:
	return cooldown_timer > 0.0


func start_cooldown() -> void:
	cooldown_timer = cooldown
	cooldown_started.emit(cooldown)
