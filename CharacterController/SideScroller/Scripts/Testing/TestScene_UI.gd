extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	SceneManager.change_scene("res://CharacterController/SideScroller/Scenes/side_scroller_test_scene.tscn", SceneManager.TransitionTypes.bluewave)
