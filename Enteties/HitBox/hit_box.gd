class_name HitBox extends Area2D

signal Damaged( damage: int )

@export var hit_sounds: Array[AudioStream] = []

func TakeDamage( damage: int ) -> void:
	print("[HitBox ", get_parent().name, "] TakeDamage: ", damage )
	Damaged.emit( damage )
	
func play_shake(sprite: Sprite2D, duration:float = 0.2, shake_count:int = 4, max_offset:int = 6):
	var tween = create_tween()
	
	# duration = Gesamtdauer des Shakes
	# shake_count = Wie oft es hin und her zappelt
	# max_offset =Maximale Pixel-Auslenkung
	
	# Setzt den Offset zu Beginn zurück
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
