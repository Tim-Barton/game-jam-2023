extends Node
class_name World

@onready var tile_map : TileMap = $TileMap

static var _instance: World = null
# Called when the node enters the scene tree for the first time.
func _ready():
	_instance = self if _instance == null else _instance
	LevelDirector.PlayMusic(LevelDirector.BGM_1)

static func get_tile_data(position: Vector2) -> TileData:
	var local_position: Vector2i = _instance.tile_map.local_to_map(position)
	return _instance.tile_map.get_cell_tile_data(0,local_position)

static func get_custom_data(position: Vector2, custom_data_name: String) -> Variant:
	var data = get_tile_data(position)
	if data:
		return data.get_custom_data(custom_data_name)
	else:
		return null
