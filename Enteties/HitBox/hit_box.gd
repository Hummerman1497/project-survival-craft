class_name HitBox extends Area2D

signal Damaged( damage: int )

@export var hit_sounds: Array[AudioStream] = []
const DAMAGE_NUMBER = preload("uid://ba6m4lmhoiyof")


func TakeDamage( damage: int ) -> void:
	print("[HitBox ", get_parent().name, "] TakeDamage: ", damage )
	init_dmg_num(damage)
	Damaged.emit( damage )
	
func play_shake(sprite: Sprite2D, duration:float = 0.2, shake_count:int = 4, max_offset:int = 6):
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
		tween.parallel().tween_property(sprite, "offset:x", target_offset.x, duration / shake_count)\
			.set_trans(Tween.TRANS_SINE)\
			.set_ease(Tween.EASE_IN_OUT)\
			.set_delay(time)
			
	# Am Ende exakt auf Null zurücksetzen
	tween.chain().tween_property(sprite, "offset", Vector2.ZERO, 0.05)

func init_dmg_num( amount : int):
	# 1. Zahl instanziieren
	var dmg_number_scene = DAMAGE_NUMBER
	var dmg_num = dmg_number_scene.instantiate()
	
	# 2. Text und Startposition (beim Gegner) setzen
	dmg_num.text = str(amount)
	var random_offset := Vector2(
		randf_range(-15.0, 15.0),
		randf_range(-10.0, 10.0)
	)
	dmg_num.global_position = global_position + random_offset
	
	# 3. An die Welt anhängen (get_tree().current_scene ist die geladene Map)
	get_tree().current_scene.add_child(dmg_num)
