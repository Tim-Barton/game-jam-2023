extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_btn_play_pressed():
	var PlayerName = $Username.text
	if PlayerName.length() == 0:
		$Instructions.visible = true
	else:
		LevelDirector.player_name = PlayerName
		SceneManager.change_scene("res://Scenes/ClimbingLevel.tscn", SceneManager.TransitionTypes.bluewave)
