class_name State_Idle extends State

@onready var walk: State = $"../Walk"
@onready var run: State = $"../Run"
@onready var attack: State= $"../Attack"



## What happens when the Player enters this State?
func Enter() -> void:
	player.UpdateAnimation("idle")
	pass


## What happens when the Player exits this State?
func Exit() -> void:
	pass


## What happens during the _process update in this State ?
func Process(_delta : float) -> State:
	if player.direction != Vector2.ZERO:
		if Input.is_action_pressed("run"):
			return run		
		return walk
	player.velocity = Vector2.ZERO
	return null


## What happens during the _physics_process update in this State ?
func Physics(_delta : float) -> State:
	return null


## What happens with the input events in this State?	
func HandleInput(_event: InputEvent) -> State:
	if _event.is_action("attack"):
		return attack
	return null
