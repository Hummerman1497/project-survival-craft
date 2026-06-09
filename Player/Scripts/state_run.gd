class_name State_Run extends State

@export var run_speed : float = 100.0

@onready var idle: State = $"../Idle"
@onready var walk: State = $"../Walk"
@onready var attack: State = $"../Attack"


## What happens when the Player enters this State?
func Enter() -> void:
	player.UpdateAnimation("run")
	


## What happens when the Player exits this State?
func Exit() -> void:
	pass


## What happens during the _process update in this State ?
func Process(_delta : float) -> State:
	if player.direction == Vector2.ZERO:
		return idle
		
	if not Input.is_action_pressed("run"):
		return walk
	player.velocity = player.direction * run_speed
	
	if player.SetDirection():
		player.UpdateAnimation("run")
	return null


## What happens during the _physics_process update in this State ?
func Physics(_delta : float) -> State:
	return null


## What happens with the input events in this State?	
func HandleInput(_event: InputEvent) -> State:
	return null
