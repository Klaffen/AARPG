class_name EnemyStateMachine extends Node

var states: Array[EnemyState]
var prev_state: EnemyState
var current_state: EnemyState


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	pass


func _process(delta: float) -> void:
	change_state(current_state.process(delta))
	pass
	
func _physics_process(delta: float) -> void:
	change_state(current_state.physics(delta))
	pass

func initialize(_enemy: Enemy) -> void:
	states = []
	
	for node in get_children():
		if node is EnemyState:
			states.append(node)
	
	for state in states:
		state.enemy = _enemy
		state.state_machine = self
		state.init()
	
	if not states.is_empty():
		change_state(states[0])
		process_mode = Node.PROCESS_MODE_INHERIT
		
	pass

func change_state(new_state: EnemyState) -> void:
	if new_state == null || new_state == current_state:
		return
		
	if current_state:
		current_state.exit()
		
	prev_state = current_state
	current_state = new_state
	current_state.enter()
	
	pass
