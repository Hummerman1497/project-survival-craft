class_name State_Attack extends State

@export var attack_walk_speed : float = 30.0

@onready var idle: State = $"../Idle"
@onready var walk: State = $"../Walk"
@onready var run: State= $"../Run"


## What happens when the Player enters this State?
func Enter() -> void:
	player.UpdateAnimation("attack")
	


## What happens when the Player exits this State?
func Exit() -> void:
	pass


## What happens during the _process update in this State ?
func Process(_delta : float) -> State:
	if player.direction == Vector2.ZERO:
		return idle
		
	if not Input.is_action_pressed("run"):
		return walk
		
	player.velocity = player.direction * attack_walk_speed
	
	
	if player.SetDirection():
		player.UpdateAnimation("attack")
	return null


## What happens during the _physics_process update in this State ?
func Physics(_delta : float) -> State:
	return null


## What happens with the input events in this State?	
func HandleInput(_event: InputEvent) -> State:
	return null
