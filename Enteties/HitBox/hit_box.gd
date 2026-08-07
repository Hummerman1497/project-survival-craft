class_name HitBox
extends Area2D

signal damaged(hurt_box: HurtBox)

@export var hit_sounds: Array[AudioStream] = []
@export var succesfull_hit_sound: Array[AudioStream] = []
@export var failed_hit_sounds: Array[AudioStream] = []
const DAMAGE_NUMBER = preload("uid://ba6m4lmhoiyof")


func take_damage(hurt_box: HurtBox) -> void:
	damaged.emit(hurt_box)


func play_shake(sprite: Sprite2D, duration: float = 0.2, shake_count: int = 4, max_offset: int = 6):
	var tween = create_tween()

	sprite.offset = Vector2.ZERO

	for i in range(shake_count):
		# Berechnet den Zeitpunkt für diesen Teilschritt
		var time = (duration / shake_count) * i

		# Die Richtung wechselt ab (links/rechts)
		var direction = 1 if i % 2 == 0 else -1

		# Intensität nimmt mit jedem Schritt ab (Ease Out Effekt)
		var intensity = max_offset * (1.0 - float(i) / shake_count)
		var target_offset = Vector2(direction * intensity, 0)

		# Tween für den Teilschritt einfügen
		tween.parallel().tween_property(sprite, "offset:x", target_offset.x, duration / shake_count) \
				.set_trans(Tween.TRANS_SINE) \
				.set_ease(Tween.EASE_IN_OUT) \
				.set_delay(time)

	# Am Ende exakt auf Null zurücksetzen
	tween.chain().tween_property(sprite, "offset", Vector2.ZERO, 0.05)


# Visualiza der Damage Number
func init_dmg_num(amount: int):
	var dmg_number_scene = DAMAGE_NUMBER
	var dmg_num = dmg_number_scene.instantiate()

	dmg_num.text = str(amount)
	var random_offset := Vector2(
		randf_range(-15.0, 15.0),
		randf_range(-10.0, 10.0),
	)
	dmg_num.global_position = global_position + random_offset

	get_tree().current_scene.add_child(dmg_num)
