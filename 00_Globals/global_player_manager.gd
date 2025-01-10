extends Node

const PLAYER = preload("res://Player/player.tscn")

var player: Player
var player_spawned: bool = false

func _ready() -> void:
	add_player_instance()
	while player_spawned == false:
		await get_tree().create_timer(0.1).timeout


func add_player_instance() -> void:
	player = PLAYER.instantiate()

	add_child(player)
	player_spawned = true
	pass

func set_player_health(health: int, max_health: int) -> void:
	player.max_health = max_health
	player.health = health


func set_player_position(_new_position: Vector2) -> void:
	player.global_position = _new_position
	pass


func set_as_parent(_parent_node: Node2D) -> void:
	if player.get_parent():
		player.get_parent().remove_child(player)

	_parent_node.add_child(player)


func unparent_player(_parent_node: Node2D) -> void:
	if player.get_parent() == _parent_node:
		_parent_node.remove_child(player)
