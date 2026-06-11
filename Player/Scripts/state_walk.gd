class_name State_Walk extends State

@export var walk_speed : float = 100.00

@onready var idle: State = $"../Idle"
@onready var run: State = $"../Run"
@onready var attack: State = $"../Attack"



## What happens when the Player enters this State?
func Enter() -> void:
	player.UpdateAnimation("walk")
	pass


## What happens when the Player exits this State?
func Exit() -> void:
	pass


## What happens during the _process update in this State ?
func Process(_delta : float) -> State:
	if player.direction == Vector2.ZERO:
		return idle
		
	if Input.is_action_pressed("run"):
		return run
		
	player.velocity = player.direction * walk_speed
	
	if player.SetDirection():
		player.UpdateAnimation("walk")
	return null


## What happens during the _physics_process update in this State ?
func Physics(_delta : float) -> State:
	return null


## What happens with the input events in this State?	
func HandleInput(_event: InputEvent) -> State:
	if _event.is_action("attack"):
		return attack
	return null
