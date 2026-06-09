class_name Player extends CharacterBody2D


var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var move_speed : float = 0
var walk_speed : float = 60.0
var run_speed : float = 100.0
var state : String = "idle"


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready():
	pass
	

func _process(delta):	
	move_speed = walk_speed
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left") # wenn beide taste gedrückt werden kein movement
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up") # wenn beide taste gedrückt werden kein movement
	
	if direction.length() > 1.0:
		direction = direction.normalized()
			
	if Input.is_action_pressed("run"):
		move_speed = run_speed
	
			
	velocity = direction * move_speed
	
	if SetState() == true || SetDirection() == true:
		UpdateAnimation()
	
func _physics_process(delta):
	move_and_slide()
	
func SetDirection() -> bool:
	if direction == Vector2.ZERO:
		return false
	
	var threshold : float = 0.3
	var x_dir : float = 0.0
	var y_dir : float = 0.0

	if direction.x > threshold:
		x_dir = 1.0
	elif direction.x < -threshold:
		x_dir = -1.0
		
	if direction.y > threshold:
		y_dir = 1.0
	elif direction.y < -threshold:
		y_dir = -1.0

	var new_dir = Vector2(x_dir, y_dir)

	if new_dir == Vector2.ZERO or new_dir == cardinal_direction:
		return false
		
	cardinal_direction = new_dir	
	
	return	true

func SetState() -> bool:
	var new_state: String = "idle" if direction == Vector2.ZERO else "walk"
	if direction == Vector2.ZERO:
		new_state = "idle"
	elif direction != Vector2.ZERO:
		if Input.is_action_pressed("run"):
			new_state = "run"
	else:
		new_state = "walk"
	
	if new_state == state:
		return false
	state = new_state
	return true
	aa
	
	
func UpdateAnimation() -> void:
	animation_player.play( state + "_" + AnimDirection() )
	pass	
	
func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "S"
	elif cardinal_direction == Vector2.UP:
		return "N"
	elif cardinal_direction == Vector2.LEFT:
		return "W"
	elif cardinal_direction == Vector2.RIGHT:
		return "O"
	elif cardinal_direction	== Vector2(-1,-1):
		return "NW"
	elif  cardinal_direction == Vector2(1,1):
		return "SO"
	elif cardinal_direction == Vector2(1,-1):
		return "NO"	
	else:
		return "SW"
		
	
