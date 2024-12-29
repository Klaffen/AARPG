class_name LevelTileMap extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LevelManager.ChangeTilemapBounds(GetTileMapBounds())
	pass # Replace with function body.

func GetTileMapBounds() -> Array[Vector2]: 
	var bounds: Array[Vector2] = []
	
	#Top left position
	bounds.append(
		Vector2(get_used_rect().position * rendering_quadrant_size)
	)
	
	#Bottom right position
	bounds.append(
		Vector2(get_used_rect().end * rendering_quadrant_size)
	)
	
	return bounds
