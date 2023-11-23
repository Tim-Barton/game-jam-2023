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
var BlueCoinScore : int = 10

#YellowCoin Count
var YellowCoinCount : int = 0
var YellowCoinTarget : int
var YellowCoinScore : int = 1

# Tick Speed
var TickSpeed : float=0.09
var delta_time : float
var next_update : float

var total_score : int = 0
var target_total_score : int = 0
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
	
	target_total_score = int(TimeTarget*10) + (BlueCoinTarget*BlueCoinScore) + (YellowCoinTarget*YellowCoinScore)
	
	if TimeTarget > 20:
		TimeInterval = TimeTarget / 30

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	delta_time += delta
	if delta_time > next_update:
		next_update = delta_time + TickSpeed
		if TimeCount < TimeTarget:
			TimeCount += TimeInterval
			if TimeCount >= TimeTarget:
				TimeCount = TimeTarget
				total_score = int(TimeTarget * 10)
				next_update = delta_time + (10*TickSpeed)
		else:
			if YellowCoinCount < YellowCoinTarget:
				next_update = delta_time + (10*TickSpeed)
				YellowCoinCount += 1
				total_score +=  YellowCoinScore
				if YellowCoinCount >= YellowCoinTarget:
					YellowCoinCount = YellowCoinTarget
			else:
				if BlueCoinCount < BlueCoinTarget:
					next_update = delta_time + (10*TickSpeed)
					BlueCoinCount += 1
					total_score +=  BlueCoinScore
					if BlueCoinCount >= BlueCoinTarget:
						BlueCoinCount = BlueCoinTarget
	#var TimeValue = 
	$lblResult.text = str(round_to_dec(TimeCount,1)).pad_decimals(1)
	$lblResult3.text = str(BlueCoinCount)
	$lblResult2.text = str(YellowCoinCount)
	$lblResult4.text = str(total_score)
	if not UploadedScore:
		UploadedScore = true
		#TODO: Calculate numeric score and player name
		SilentWolf.Scores.save_score(LevelDirector.player_name, target_total_score)
	
func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)
