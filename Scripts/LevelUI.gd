extends Control

@export var character_node : Player
var time: float = 0.0
var minutes: int = 0
var seconds: int = 0
var msec: int = 0 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Stamina Bar
	$StaminaBar.value = clamp((character_node.cur_stamina/character_node.max_stamina) * $StaminaBar.max_value, $StaminaBar.min_value, $StaminaBar.max_value)
	
	#Timer
	if character_node.player_alive:
		time += delta
		msec = fmod(time, 1) * 100
		seconds = fmod(time, 60)
		minutes = fmod(time, 3600) / 60
	else:
		LevelDirector.EndLevel((minutes * 60) + seconds)
		LevelDirector.StopMusic()
				
	$Minutes.text = get_time_formatted()
	
	#Coins
	$GoldCoins.text = str(LevelDirector.yellow_coins)
	$BlueCoins.text = str(LevelDirector.blue_coins)
	
func get_time_formatted() -> String:
	return "%02d:%02d.%03d" % [minutes, seconds, msec]
