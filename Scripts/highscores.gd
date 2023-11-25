extends Control

const ScoreItem = preload("res://addons/silent_wolf/Scores/ScoreItem.tscn")
var list_index = 0

var LoadedLeaderBoard : bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	SilentWolf.configure({
		"api_key": "6NW2Oigo5P4Zb8GYCZBMl6jN2I3ug4pn3Ktr2FGk",
		"game_id": "GameJam2023",
		"log_level": 1
	})
	SilentWolf.configure_scores({
		"open_scene_on_close": "res://Scenes/end_level.tscn"
	})

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not LoadedLeaderBoard:
		LoadedLeaderBoard = true
		var scores = SilentWolf.Scores.scores
		var sw_result = await SilentWolf.Scores.get_scores(100).sw_get_scores_complete
		$Loading.visible = false
		scores = sw_result.scores
		for score in scores:
			add_item(score.player_name, str(int(score.score)))
	
func add_item(player_name: String, score_value: String) -> void:
	var item = ScoreItem.instantiate()
	list_index += 1
	item.get_node("PlayerName").text = str(list_index) + str(". ") + player_name
	item.get_node("Score").text = score_value
	item.offset_top = list_index * 100
	$"HighScores/ScoreItemContainer".add_child(item)
