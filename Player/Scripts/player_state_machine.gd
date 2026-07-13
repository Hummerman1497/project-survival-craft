class_name PlayerStateMachine
extends Node

var states: Array[State]
var prev_state: State
var current_state: State


func _ready():
	process_mode = Node.PROCESS_MODE_DISABLED
	pass


func _process(delta: float):
	for state in states:
		if state.cooldown_timer > 0.0:
			state.cooldown_timer -= delta
			if state == current_state:
				print(state.name, " Cooldown: ", state.cooldown_timer)

	ChangeState(current_state.Process(delta))


func _physics_process(delta: float):
	ChangeState(current_state.Physics(delta))


func _unhandled_input(event):
	ChangeState(current_state.HandleInput(event))


func Initialize(_player: Player) -> void:
	states = []

	for node in get_children():
		if node is State:
			states.append(node)

	if states.size() > 0:
		states[0].player = _player
		ChangeState(states[0])
		process_mode = Node.PROCESS_MODE_INHERIT


func ChangeState(new_state: State) -> void:
	if new_state == null || new_state == current_state:
		return

	if new_state.is_on_cooldown():
		print("[SM]", new_state.name, " Cooldown: ", new_state.cooldown_timer)
		return

	if current_state:
		current_state.Exit()
		current_state.start_cooldown() # emited ebenfalls ein singal cooldown_stated(cooldown)
		state_start_cooldown(current_state)

	prev_state = current_state
	current_state = new_state
	current_state.Enter()


func state_start_cooldown(state: State) -> void: # nimmt den State.Cooldown und erstellt einen Timer, Timer.timeout emitete dann über func ein signal	
	var cooldown_time = state.cooldown
	if cooldown_time > 0.0:
		var temp_timer = get_tree().create_timer(cooldown_time)
		temp_timer.timeout.connect(state_cooldown_finished.bind(state))


func state_cooldown_finished(state: State):
	state.cooldown_finished.emit()
	print("[SM] ", state.name, ": Cooldown finished")
