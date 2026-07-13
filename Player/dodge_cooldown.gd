extends Node2D

@onready var progress_bar: TextureProgressBar = $TextureProgressBar
@export var dodge: State_Dodge

var is_coolingdown: bool = false
var cooldown: float
var current_time: float


func _ready() -> void:
	progress_bar.step = 0.01
	if dodge:
		dodge.cooldown_started.connect(progress_bar_cooldown)
	else:
		print("Warnung: Dodge State wurde im Inspektor nicht zugewiesen!")


func _process(delta: float) -> void:
	if is_coolingdown:
		if progress_bar.value < cooldown:
			current_time += delta
			progress_bar.value = current_time
		else:
			cd_end_tween()
			is_coolingdown = false
			current_time = 0


func progress_bar_cooldown(cd: float):
	cooldown = cd
	is_coolingdown = true
	progress_bar.max_value = cooldown
	progress_bar.value = 0


func cd_end_tween() -> void:
	var tween = create_tween()
	# modulate kurz auf 200% Helligkeit setzen, dann zurück auf 100%
	tween.tween_property(progress_bar, "modulate", Color(2.0, 2.0, 2.0, 1.0), 0.0)
	tween.tween_property(progress_bar, "modulate", Color(2.0, 2.0, 2.0, 1.0), 0.1)
	tween.tween_property(progress_bar, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.2)
