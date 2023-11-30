extends Node

@export var character_node : Player
var player_name : String = "Unknown Player"
var player_score : float = 0.0
var blue_coins : int = 0
var yellow_coins : int = 0

var _olddebugmessage : String = ""
var _debugmessage : String = ""

@export var level_countout_seconds : int = 2
var level_countout : Timer
var start_end_level : bool = false
var end_level : bool = false
var change_level : bool = false

var SFXManager : AudioStreamPlayer
var MusicManager : AudioStreamPlayer
var CameraDirector : CameraDirector

const JUMP = preload("res://SFX/350905__cabled-mess__jump-c-05.wav")
const COLLECTIBLE = preload("res://SFX/coin.wav")
const DEATH = preload("res://SFX/Death.mp3")
const HIT = preload("res://SFX/hitHurt.wav")
const SCENECHANGE = preload("res://SFX/404750__owlstorm__retro-video-game-sfx-collect-5.wav")
const BGM_1 = preload("res://SFX/My Song  (crap, timing is wrong do not use) 2.ogg")
const BGM_GameOver = preload("res://SFX/Game_Over_BGM_-_30112023_12.58_pm.mp3")
const BGM_Level = preload("res://SFX/Level.Title_BGM_-_30112023_12.44_pm.mp3")
const BGM_SciFi = preload("res://SFX/Scifi_Lvl_BGM_-_30112023_1.37_pm.mp3")
const BGM_Title = preload("res://SFX/Title_BGM_-_30112023_1.13_pm.mp3")

func _ready():
	var new_level_countout := Timer.new()
	new_level_countout.name = "level_countout"
	add_child(new_level_countout)
	level_countout = get_node("level_countout")
	level_countout.wait_time = level_countout_seconds
	level_countout.one_shot = true
	
	var SFXPlayerNode := AudioStreamPlayer.new()
	SFXPlayerNode.name = "SFX"
	add_child(SFXPlayerNode)
	SFXManager = get_node("SFX")
	
	var MusicPlayerNode := AudioStreamPlayer.new()
	MusicPlayerNode.name = "Music"
	MusicPlayerNode.volume_db = -17.5
	add_child(MusicPlayerNode)
	MusicManager = get_node("Music")

func ResetLevel():
	start_end_level = false
	end_level = false
	change_level = false
	yellow_coins = 0
	blue_coins = 0

func _process(delta):
	if start_end_level:
		if !end_level:
			level_countout.start()
			end_level = true
		else:
			if level_countout.is_stopped() && not change_level:
				change_level = true
				SceneManager.change_scene("res://Scenes/end_level.tscn", SceneManager.TransitionTypes.dissolve)
			
func EndLevel(final_time : float):
	start_end_level = true
	player_score = final_time
				
func DebugMessage(Message : String) -> void:
	_debugmessage = Message
	if _debugmessage != _olddebugmessage:
		var time = Time.get_time_dict_from_system()
		
		var time_return = str(time.hour) +":"+str(time.minute)+":"+str(time.second)
		print(time_return, " : ", Message)
		_olddebugmessage = _debugmessage
		
func PlaySound(AudioFilename : AudioStream) -> void:
	SFXManager.stream = AudioFilename
	SFXManager.play()

func PlayMusic(AudioFilename : AudioStream) -> void:
	MusicManager.stream = AudioFilename
	MusicManager.play()

func StopMusic() -> void:
	MusicManager.stop()
