class_name EnemyStateWander extends EnemyState

@export var animation_name: String = "walk"
@export var wander_speed: float = 20.0

@export_category("AI")
@export var state_animation_duration: float = 0.5
@export var state_cycles_min: int = 1
@export var state_cycles_max: int = 3
@export var next_state: EnemyState

var _timer: float
var _direction: Vector2


func init() -> void:
	pass


func enter() -> void:
	_timer = randi_range(state_cycles_min, state_cycles_max) * state_animation_duration
	
	var random_direction_id = randi_range(0, 3)
	_direction = enemy.DIR_4[random_direction_id]
	enemy.set_direction(_direction)
	enemy.velocity = _direction * wander_speed
	
	enemy.update_animation(animation_name)
	pass
	

func exit() -> void:
	pass


func process(_delta: float) -> EnemyState:
	_timer -= _delta
	
	if _timer <= 0:
		return next_state
	
	return null
	

func physics(_delta: float) -> EnemyState:
	return null
	