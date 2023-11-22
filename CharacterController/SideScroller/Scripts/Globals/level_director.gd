extends Node

var player_score : float = 0.0
var blue_coins : int = 0
var yellow_coins : int = 0

var _olddebugmessage : String = ""
var _debugmessage : String = ""

func DebugMessage(Message : String) -> void:
	_debugmessage = Message
	if _debugmessage != _olddebugmessage:
		var time = Time.get_time_dict_from_system()
		
		var time_return = str(time.hour) +":"+str(time.minute)+":"+str(time.second)
		print(time_return, " : ", Message)
		_olddebugmessage = _debugmessage
