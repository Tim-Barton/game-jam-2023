extends Node2D

@export var SpawnBox : float = 800
@export var LowChance : float = 0.1
@export var HighChance : float = 0.7
@export var HighYValue : float = -500
@export var SpawnFrom : Node2D

const Boulder = preload("res://CharacterController/SideScroller/Prefabs/FallingBoulder.tscn")

var CurrentChance : float
var SpawnTimer : Timer
var LowYValue : float
# Called when the node enters the scene tree for the first time.
func _ready():
	LowYValue = self.global_position.y
	SpawnTimer = $BoulderSpawnTimer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	CurrentChance = clamp((self.global_position.y-LowYValue)/(HighYValue+LowYValue),LowChance,HighChance)

func SpawnBoulder() -> void:
	var newBoulder = Boulder.instantiate()
	newBoulder.position = Vector2(randf_range(position.x, position.x+SpawnBox),position.y)
	SpawnFrom.add_child(newBoulder)

func _on_boulder_spawn_timer_timeout():
	if CurrentChance < randf_range(0,1):
		SpawnBoulder()
