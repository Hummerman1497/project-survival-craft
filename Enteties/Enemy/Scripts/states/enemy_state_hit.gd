class_name EnemyStateHit
extends EnemyState

@export var anim_name: String = "hit"
@export var kockback_speed: float = 150.0
@export var decelerater_speed: float = 10.0

@export_category("AI")
@export var next_state: EnemyState

var _direction: Vector2
var _animation_finished: bool = false
var _damage_position: Vector2


## What happens when we initialize this state?
func init() -> void:
	enemy.enemy_damaged.connect(_on_enemy_damaged)
	pass


## What happens when the enemy enters this state?
func enter() -> void:
	enemy.invulnerable = true
	_animation_finished = false

	_direction = enemy.global_position.direction_to(_damage_position)

	enemy.set_direction(_direction)
	enemy.velocity = _direction * -kockback_speed

	enemy.update_animation(anim_name)
	enemy.animation_player.animation_finished.connect(_on_animation_finished)
	pass


## What happens when the enemy exits this state?	
func exit() -> void:
	enemy.invulnerable = false
	enemy.animation_player.animation_finished.disconnect(_on_animation_finished)
	pass


## Whta happen during the _process update in this state?
func process(delta: float) -> EnemyState:
	if _animation_finished == true:
		return next_state
	enemy.velocity -= enemy.velocity * decelerater_speed * delta
	return null


## What happens during the _physics_process update in this state?
func physics(_delta: float) -> EnemyState:
	return null


func _on_enemy_damaged(hurt_box: HurtBox) -> void:
	_damage_position = hurt_box.global_position
	state_machine.change_state(self)


func _on_animation_finished(_a: String) -> void:
	_animation_finished = true
