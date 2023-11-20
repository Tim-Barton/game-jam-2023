extends Sprite2D

@export var CameraSpeed = 100

@onready var _follower :PathFollow2D = get_parent()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	_follower.set_progress(_follower.get_progress() + CameraSpeed*delta)
