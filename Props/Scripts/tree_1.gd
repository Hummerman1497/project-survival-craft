class_name Wooden_Tree
extends Node2D

@export var health: int = 1
@export var resource_drop: int = 3

@onready var hit_box: HitBox = $HitBox
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var tree_sprite: Sprite2D = $TreeSprite
@onready var stump_sprite: Sprite2D = $StrumpSprite

var is_dead: bool = false


func _ready():
	$HitBox.damaged.connect(take_damage)

	# Startet die Wind Animation an einem random punkt damit die Bäume nicht synchron sind
	animation_player.play("idle_wind")
	var anim_length = animation_player.get_animation("idle_wind").length
	var random_start_time = randf_range(0.0, anim_length)
	animation_player.seek(random_start_time, true)
	animation_player.speed_scale = randf_range(0.5, 0.8)


func take_damage(hurt_box: HurtBox) -> void:
	health -= hurt_box.damage

	if health >= 1:
		hit_box.play_shake(tree_sprite)
	if health < 1 and is_dead == false:
		tree_sprite.visible = false
		stump_sprite.visible = true
		#queue_free()
		$ItemSpawner.spawn_item(3)
		is_dead = true
		hit_box.set_deferred("monitorable", false)
