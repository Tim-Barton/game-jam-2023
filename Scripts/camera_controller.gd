extends Node
class_name CameraDirector

@export_group("Camera")
@export var camera_node : Camera2D
@export var acceleration : float
@export var deceleration : float
@export var max_movement_speed : float
@export var viewport_region : Rect2

@export_group("Target")
@export var target_node : Node2D
@export var target_node_offset : Vector2 = Vector2(0,0)

@export_group("Shake")
@export var shake_strength : float = 0.0
@export var shake_decay_rate : float = 5.0
@export var noise_shake_speed : float = 30.0
@export var noise_shake_strength : float = 60.0
@export var TestShake : bool = false


@onready var noise = FastNoiseLite.new()
@onready var rand = RandomNumberGenerator.new()

var noise_i : float = 0.0
var from_location : Vector2
var to_location: Vector2
var from_zoom : Vector2
var to_zoom : Vector2
var current_position : Vector2
var current_zoom : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	LevelDirector.CameraDirector = self
	from_location = camera_node.position
	to_location = from_location
	from_zoom = camera_node.zoom
	to_zoom = from_zoom
	
	rand.randomize()
	noise.seed = rand.seed
	noise.frequency = 0.5

func shake_screen() -> void:
	shake_strength = noise_shake_speed
	
func set_target_vector(x : float, y : float) -> void:
	to_location = Vector2(x,y)
	
func set_target_zoom(x : float, y : float) -> void:
	to_zoom = Vector2(x,y)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	current_position = camera_node.position
	current_zoom = camera_node.zoom
		
	if target_node:
		to_location = target_node.global_position+target_node_offset
	if current_position == to_location && from_location != to_location:
		#Reest movement from
		from_location = to_location
	elif current_position != to_location:
		camera_node.position = SetCameraPosition(GetVectorChange(from_location, to_location, current_position, acceleration, deceleration, max_movement_speed, delta))
		
	if TestShake:
		shake_screen()
		TestShake = false
		
	if current_zoom == to_zoom && from_zoom != to_zoom:
		#Reest movement from
		from_zoom = to_zoom
	elif current_zoom != to_zoom:
		camera_node.zoom = GetVectorChange(from_zoom, to_zoom, current_zoom, acceleration, deceleration, max_movement_speed, delta)
	shake_strength = lerp(shake_strength, 0.0, shake_decay_rate * delta)
	camera_node.offset = SetCameraPosition(ShakeVector(delta))
	
func SetCameraPosition(NominatedPosition : Vector2) -> Vector2:
	return Vector2(clamp(NominatedPosition.x,viewport_region.position.x,viewport_region.position.x+viewport_region.size.x),clamp(NominatedPosition.y,viewport_region.position.y,viewport_region.position.y+viewport_region.size.y))

func ShakeVector(delta : float) -> Vector2:
	noise_i += delta * noise_shake_speed
	return Vector2(noise.get_noise_2d(1, noise_i) * shake_strength, noise.get_noise_2d(100, noise_i)*shake_strength)
	
func GetVectorChange(from : Vector2, to : Vector2, current : Vector2, _acceleration : float, _deceleration : float, _max_speed : float, delta : float) -> Vector2:
	var shift_rate = _acceleration
	var mid_x = abs(to.x - from.x)/2
	var mid_y = abs(to.y - from.y)/2
	var x_travelled = abs(current.x - from.x)
	var y_travelled = abs(current.y - from.y)
	if x_travelled >= mid_x && y_travelled >= mid_y:
		shift_rate = _deceleration
	
	return Vector2(lerp(current.x, to.x, clamp(shift_rate * delta, 0, _max_speed)), lerp(current.y, to.y, clamp(shift_rate * delta, 0, _max_speed)))
