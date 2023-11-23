extends Node

@export var character_node : Player
var player_name : String = "Unknown Player"
var player_score : float = 0.0
var blue_coins : int = 0
var yellow_coins : int = 0

var _olddebugmessage : String = ""
var _debugmessage : String = ""

@export var level_countout_seconds : int = 5
var level_countout : Timer
var start_end_level : bool = false
var end_level : bool = false
var change_level : bool = false

func _ready():
	var new_level_countout := Timer.new()
	new_level_countout.name = "level_countout"
	add_child(new_level_countout)
	level_countout = get_node("level_countout")
	level_countout.wait_time = level_countout_seconds
	level_countout.one_shot = true

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
