class_name State_Walk
extends State

@export var walk_speed: float = 100.00

@onready var idle: State = $"../Idle"
@onready var run: State = $"../Run"
@onready var attack: State = $"../Attack"
@onready var dodge: State = $"../Dodge"

var steering_factor: float = 15.0


## What happens when the Player enters this State?
func Enter() -> void:
	player.UpdateAnimation("run")
	pass


## What happens when the Player exits this State?
func Exit() -> void:
	pass


## What happens during the _process update in this State ?
func Process(_delta: float) -> State:
	if player.direction == Vector2.ZERO:
		return idle

	if Input.is_action_pressed("run"):
		return run

	var desired_velocity = player.direction * walk_speed
	var steering_vector = desired_velocity - player.velocity
	player.velocity += steering_vector * steering_factor * _delta

	if player.SetDirection():
		player.UpdateAnimation("run")
	return null


## What happens during the _physics_process update in this State ?
func Physics(_delta: float) -> State:
	return null


## What happens with the input events in this State?	
func HandleInput(_event: InputEvent) -> State:
	if _event.is_action_pressed("attack"):
		return attack
	if _event.is_action_pressed("dodge"):
		return dodge
	return null
