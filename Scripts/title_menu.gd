extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	if LevelDirector.player_name != "Unknown Player":
		$Username.text = LevelDirector.player_name
	LevelDirector.PlayMusic(LevelDirector.BGM_Title)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_btn_play_pressed():
	var PlayerName = $Username.AlphaNumericOnly($Username.text)
	if PlayerName.length() == 0:
		$Instructions.visible = true
	else:
		LevelDirector.player_name = PlayerName
		SceneManager.change_scene("res://Scenes/ClimbingLevel.tscn", SceneManager.TransitionTypes.bluewave)


func _on_btn_high_scores_pressed():
		SceneManager.change_scene("res://Scenes/highscores.tscn", SceneManager.TransitionTypes.bluewave)
