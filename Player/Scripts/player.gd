class_name Player extends CharacterBody2D

signal direction_changed(new_direction: Vector2)
signal player_damaged(hurt_box: HurtBox)

const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO

var invulnerable: bool = false

@export var health: int = 6
@export var max_health: int = 6

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var effect_animation_player: AnimationPlayer = $EffectAnimationPlayer
@onready var hit_box: HitBox = $HitBox
@onready var sprite: Sprite2D = $Sprite2D
@onready var state_machine: PlayerStateMachine = $StateMachine

func _input(_event):
	#if event.is_action_pressed("ui_cancel") and PauseMenu.is_paused:
	#	get_tree().quit()
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerManager.player = self
	state_machine.initialize(self)
	hit_box.damaged.connect(_take_damage)
	update_health(99)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	#direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized()
	pass

func _physics_process(_delta: float) -> void:
	move_and_slide()

func set_direction() -> bool:
	if direction == Vector2.ZERO:
		return false

	var direction_id: int = int( round( (direction + cardinal_direction * 0.1).angle() / TAU * DIR_4.size() ))
	var new_direction = DIR_4[direction_id]

	if new_direction == cardinal_direction:
		return false

	cardinal_direction = new_direction
	direction_changed.emit(new_direction)

	#Flip sprite if looking left
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1

	return true


func update_animation(state: String) -> void:
	animation_player.play(state + "_" + animation_direction())
	pass


func animation_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"

	elif cardinal_direction == Vector2.UP:
		return "up"

	else:
		return "side"

func _take_damage(hurt_box: HurtBox) -> void:
	if invulnerable == true:
		return

	update_health(-hurt_box.damage)

	if health > 0:
		player_damaged.emit(hurt_box)
	else:
		player_damaged.emit(hurt_box)
		update_health(max_health)

	pass

func update_health(delta: int) -> void:
	health = clampi(health + delta, 0, max_health)

	PlayerHud.update_health(health, max_health)

	if health <= 0:
		#Player ded
		pass

	pass


func make_invulnerable(_duration: float = 1.0) -> void:
	invulnerable = true
	hit_box.monitoring = false

	await get_tree().create_timer(_duration).timeout
	invulnerable = false
	hit_box.monitoring = true
	pass
