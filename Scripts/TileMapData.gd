extends Node
class_name World

@onready var tile_map : TileMap = $TileMap_data

static var _instance: World = null
# Called when the node enters the scene tree for the first time.
func _ready():
	_instance = self if _instance == null else _instance
	LevelDirector.PlayMusic(LevelDirector.BGM_Level)
	tile_map.visible = false
	
func _process(delta):
	var hour = $WeatherSystem/CanvasModulate.get_hour()
	var light = get_node("Character/PointLight2D")

	if !hour == 0:
		if hour >= 15 and hour <= 24: 
			light.process_mode = 0 # = Mode: Inherit
			light.show()
		elif hour >= 0 and hour <= 7:
			light.process_mode = 0 # = Mode: Inherit
			light.show()
		else:
			light.process_mode = 4 # = Mode: Inherit
			light.hide()
			
		
static func get_tile_data(position: Vector2) -> TileData:
	var local_position: Vector2i = _instance.tile_map.local_to_map(position)
	return _instance.tile_map.get_cell_tile_data(0,local_position)

static func get_custom_data(position: Vector2) -> Variant:
	var data : TileData = get_tile_data(position)
	
	if data:
		return data.get_custom_data("tdata") #custom_data_name)
	else:
		return null

static func get_custom_data_by_id(position: Vector2, id: int) -> Variant:
	var data : TileData = get_tile_data(position)
	
	if data:
		return data.get_custom_data_by_layer_id(id)
	else:
		return null
		

	
