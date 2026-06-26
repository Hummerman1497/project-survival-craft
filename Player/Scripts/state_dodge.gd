class_name State_Dodge extends State

@export var dodge_speed : float = 600.0
@export var dodge_duration: float = 0.07
@export var dodge_cooldown: float = 1.5
@export var dodge_sound: Array[AudioStream] = []


@onready var idle: State = $"../Idle"
@onready var walk: State = $"../Walk"
@onready var attack: State = $"../Attack"
@onready var audio: AudioStreamPlayer2D = $"../../Audio/Audio_Hit"

var is_dodging: bool = false
var dodge_finished : bool = false

var start_direction: Vector2 = Vector2.ZERO



## What happens when the Player enters this State?
func Enter() -> void:
	player.UpdateAnimation("dodge")
	start_direction = player.direction
	is_dodging = true
	dodge_finished = false
	audio.stream = GetRanSound()		
	audio.play()
	
	
	await get_tree().create_timer(dodge_duration).timeout	
	is_dodging = false
	dodge_finished = true

	 
	 
## What happens when the Player exits this State?
func Exit() -> void:
	
	is_dodging = false
	dodge_finished = false


## What happens during the _process update in this State ?
func Process(_delta : float) -> State:
	if dodge_finished:
		if player.direction == Vector2.ZERO:
			return idle		
		if not Input.is_action_pressed("run"):
			return walk
		
	if is_dodging:
		player.velocity = start_direction * dodge_speed
	# wenn der Player Idle ist, dodge in die gespeicherte cardinal_direction	
	if is_dodging and start_direction == Vector2.ZERO:
		player.velocity = player.cardinal_direction * dodge_speed	
	
	return null

## What happens during the _physics_process update in this State ?
func Physics(_delta : float) -> State:
	return null


## What happens with the input events in this State?	
func HandleInput(_event: InputEvent) -> State:
	if _event.is_action_pressed("attack"):
		return attack	
	return null
 
func GetRanSound() -> AudioStream:
	if dodge_sound.is_empty():
		return null
	return dodge_sound.pick_random()
