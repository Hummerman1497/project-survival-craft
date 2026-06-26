class_name State_Attack extends State

@export var attack_walk_speed : float = 20.0
@export var attack_sounds: Array[AudioStream] = []
@export var hit_sound: Array[AudioStream] = []
var attacking : bool = false

@onready var idle: State = $"../Idle"
@onready var walk: State = $"../Walk"
@onready var run: State= $"../Run"
@onready var anim_sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var hurt_box: HurtBox = $"../../Interactions/HurtBox"
@onready var attack: State = $"."
@onready var audio_whosh: AudioStreamPlayer2D = $"../../Audio/Swing_Whosh"
@onready var audio_hit: AudioStreamPlayer2D = $"../../Audio/Audio_Hit"



## What happens when the Player enters this State?
func Enter() -> void:
	if not hurt_box.hurtbox_hit.is_connected(_on_hurt_box_hit):
		hurt_box.hurtbox_hit.connect(_on_hurt_box_hit)
	anim_sprite.animation_finished.connect(EndAttack)	
	
	StartAttack()


## What happens when the Player exits this State?
func Exit() -> void:
	attacking = false
	anim_sprite.speed_scale = 1.0
	hurt_box.monitoring = false
	if anim_sprite.animation_finished.is_connected(EndAttack):
		anim_sprite.animation_finished.disconnect(EndAttack)
	if hurt_box.hurtbox_hit.is_connected(_on_hurt_box_hit):
		hurt_box.hurtbox_hit.disconnect(_on_hurt_box_hit)

## Startet (oder wiederholt) den eigentlichen Angriff
func StartAttack() -> void:
	player.getSnappedDirectionToMouse()
	player.GetAngleToMouse()
	audio_whosh.stream = GetRanSound()		
	audio_whosh.play()
	# Sicherheitsnetz: falls der Sprite direkt (statt nur via AnimationPlayer)
	# beteiligt ist, hier ebenfalls hart auf Frame 0 zurücksetzen.
	anim_sprite.stop()
	anim_sprite.frame = 0

	player.UpdateAnimation("attack")
	anim_sprite.speed_scale = 3
	hurt_box.monitoring = false

	attacking = true
	await get_tree().create_timer(0.075).timeout

	# Falls der State inzwischen verlassen wurde (z.B. durch Hit/Dodge), nicht mehr aktivieren
	if attacking:
		hurt_box.monitoring = true


## What happens during the _process update in this State ?
func Process(_delta : float) -> State:
	player.velocity = player.direction * attack_walk_speed


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

	# Maustaste immer noch gehalten? -> direkt nächsten Angriff starten (Loop)
	if Input.is_action_pressed("attack"):
		StartAttack()

func GetRanSound() -> AudioStream:
	if attack_sounds.is_empty():
		return null
	return attack_sounds.pick_random()


func _on_hurt_box_hit(hitbox: HitBox) -> void:	
	if hitbox and not hitbox.hit_sounds.is_empty():
		audio_hit.stream = hitbox.hit_sounds.pick_random()
		audio_hit.play()
