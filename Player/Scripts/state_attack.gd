class_name State_Attack extends State

var attacking : bool = false

@export var attack_walk_speed : float = 20.0

@onready var idle: State = $"../Idle"
@onready var walk: State = $"../Walk"
@onready var run: State= $"../Run"
@onready var anim_sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var hurt_box: HurtBox = $"../../Interactions/HurtBox"



## What happens when the Player enters this State?
func Enter() -> void:
	player.getSnappedDirectionToMouse()	
	player.UpdateAnimation("attack")
	anim_sprite.speed_scale = 3
	anim_sprite.animation_finished.connect(EndAttack)
	
	
	attacking = true
	await get_tree().create_timer(0.075).timeout
	hurt_box.monitoring = true
	


## What happens when the Player exits this State?
func Exit() -> void:
	anim_sprite.speed_scale = 1.0
	hurt_box.monitoring = false
	if anim_sprite.animation_finished.is_connected(EndAttack):
		anim_sprite.animation_finished.disconnect(EndAttack)
		
	


## What happens during the _process update in this State ?
func Process(_delta : float) -> State:
	player.velocity = player.direction * attack_walk_speed
		
	#if player.SetDirection():
		#player.UpdateAnimation("attack")
		
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return null


## What happens during the _physics_process update in this State ?
func Physics(_delta : float) -> State:
	return null


## What happens with the input events in this State?	
func HandleInput(_event: InputEvent) -> State:
	return null
	
	
func EndAttack() -> void:
	attacking = false
		
