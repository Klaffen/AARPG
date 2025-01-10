extends CanvasLayer

var hearts: Array[HeartGUI] = []



func _ready() -> void:
	for child in $Control/HeartContainer.get_children():
		if child is HeartGUI:
			hearts.append(child)
			child.visible = false
	pass


func update_health(_health: int, _max_health: int) -> void:
	update_max_health(_max_health)
	
	for i in _max_health:
		update_heart(i, _health)
		pass
	pass

func update_heart(_index: int, _health: int) -> void:
	var _value: int = clampi(_health - _index * 2, 0, 2)
	hearts[_index].value = _value
	pass

func update_max_health(_max_health: int) -> void:
	var _heart_count: int = roundi(_max_health * 0.5)
	
	for i in hearts.size():
		hearts[i].visible = i <_heart_count
	pass
