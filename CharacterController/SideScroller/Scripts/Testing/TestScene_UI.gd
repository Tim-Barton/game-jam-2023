extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	#Currently getting an error, maybe cos there's less than 10 scores available
	#var sw_result: Dictionary = await SilentWolf.Scores.get_scores().sw_get_scores_complete
	#print("Scores: " + str(sw_result.scores))
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	LevelDirector.ResetLevel()
	SceneManager.change_scene("res://Scenes/title.tscn", SceneManager.TransitionTypes.bluewave)

func _on_pressed_retry():
	LevelDirector.ResetLevel()
	SceneManager.change_scene("res://Scenes/ClimbingLevel.tscn", SceneManager.TransitionTypes.bluewave)


func _on_pressed_hs():
	LevelDirector.ResetLevel()
	SceneManager.change_scene("res://Scenes/highscores.tscn", SceneManager.TransitionTypes.bluewave)
