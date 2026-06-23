class_name Enemy extends CharacterBody2D

signal direction_change ( new_direction : Vector2)
signal enemy_damaged()

@export var health : int = 3

var cadinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var player : Player
var invulnerable : bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D


func _physics_process(_delta: float):
	move_and_slide()
	

	
