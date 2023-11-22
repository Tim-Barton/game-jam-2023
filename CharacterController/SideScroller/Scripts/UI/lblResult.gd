extends Node

#UploadScore
var UploadedScore : bool = false

#Time Count
var TimeCount : float = 0.0
var TimeInterval : float = 0.1
var TimeTarget : float

#BlueCoin Count
var BlueCoinCount : int = 0
var BlueCoinTarget : int

#YellowCoin Count
var YellowCoinCount : int = 0
var YellowCoinTarget : int

# Tick Speed
var TickSpeed : float=0.03
var delta_time : float
var next_update : float
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
	TimeTarget = LevelDirector.player_score
	BlueCoinTarget = LevelDirector.blue_coins
	YellowCoinTarget = LevelDirector.yellow_coins

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	delta_time += delta
	if delta_time > next_update:
		next_update = delta_time + TickSpeed
		if TimeCount < TimeTarget:
			TimeCount += TimeInterval
			if TimeCount >= TimeTarget:
				TimeCount = TimeTarget
		else:
			if BlueCoinCount < BlueCoinTarget:
				BlueCoinCount += 1
				if BlueCoinCount >= BlueCoinTarget:
					BlueCoinCount = BlueCoinTarget
			else:
				if YellowCoinCount < YellowCoinTarget:
					YellowCoinCount += 1
					if YellowCoinCount >= YellowCoinTarget:
						YellowCoinCount = YellowCoinTarget
	
	$lblResult.text = str(TimeCount)
	$lblResult2.text = str(BlueCoinCount)
	$lblResult3.text = str(YellowCoinCount)
	
	if not UploadedScore:
		UploadedScore = true
		#TODO: Calculate numeric score and player name
		SilentWolf.Scores.save_score("test", 100)
	

