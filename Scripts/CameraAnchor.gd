extends Node2D

@export var CameraSpeed = 100

@onready var _follower :PathFollow2D = get_parent()


# Called when the node enters the scene tree for the first time.
func _ready():
	_follower.set_loop(false)
	$Gold_Coin.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	_follower.set_progress(_follower.get_progress() + CameraSpeed*delta)
	#print(_follower.get_progress())
