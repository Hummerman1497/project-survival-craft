class_name Wooden_Tree extends Node2D

@export var health : int = 5
@export var resource_drop : int = 3

@onready var hit_box: HitBox = $HitBox
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready():
	$HitBox.Damaged.connect(TakeDamage)

func TakeDamage( _damage:int)->void:
	health	-= _damage	
	
	if health >= 1:		
		hit_box.play_shake(sprite_2d)
	else: 
		queue_free()
		$ItemSpawner.spawn_item(3)
			
	
