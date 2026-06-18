class_name Player extends CharacterBody2D


var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var mouse_position : Vector2 = Vector2.ZERO

@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

signal DirectionChanged(new_direction : Vector2)
signal AngleToMouse(angel_to_mouse: float)

func _ready():
	state_machine.Initialize(self)
	pass
	

func _process(delta):		
	direction = Vector2(
		Input.get_axis("left","right"),
		Input.get_axis("up","down")
	).normalized()
			
	
	
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
	DirectionChanged.emit(new_dir)
	
	return	true


	
func UpdateAnimation(state:String ) -> void:
	var anim_name : String = state + "_" + AnimDirection()
	if animation_player.current_animation == anim_name:
		animation_player.stop()
 
	animation_player.play( anim_name )
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

	


func getSnappedDirectionToMouse() -> void:
	# Schritt 1: Vektor vom Spieler zur Maus berechnen und normalisieren
	mouse_position = get_global_mouse_position()
	var direction_to_mouse: Vector2 = (mouse_position - global_position).normalized()
	
	# Schritt 2: Winkel im Bogenmaß (Radiant) holen
	var angle: float = direction_to_mouse.angle()
	print("[Player] Angle to mouse: ", angle)
	# Winkel in 45-Grad-Schritten (TAU / 8) einrasten lassen
	var snapped_angle: float = snapped(angle, TAU / 8.0)
	
	# Den eingerasteten Winkel zurück in einen sauberen Richtungs-Vektor umwandeln
	var new_dir: Vector2 = Vector2.from_angle(snapped_angle)
	
	# Vektor-Werte runden, um ungenaue Kommastellen (wie 0.7071) exakt auf 1 oder -1 zu bringen
	cardinal_direction = new_dir.round()
	DirectionChanged.emit(cardinal_direction)


func pick_up_item(item_stats: Array):
	print(item_stats)
	
func GetAngleToMouse()-> void:
	
	mouse_position = get_global_mouse_position()
	var direction_to_mouse: Vector2 = (mouse_position - global_position).normalized()
	var angle: float = direction_to_mouse.angle()	
	AngleToMouse.emit(angle)
