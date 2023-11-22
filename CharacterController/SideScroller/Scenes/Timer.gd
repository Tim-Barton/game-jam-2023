extends Label

var time: float = 0.0
var minutes: int = 0
var seconds: int = 0
var msec: int = 0 

@export var level_countout_seconds : int = 5
@export var character_node : Player

var level_countout : Timer
var end_level : bool = false
var change_level : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var new_level_countout := Timer.new()
	new_level_countout.name = "level_countout"
	add_child(new_level_countout)
	level_countout = get_node("level_countout")
	level_countout.wait_time = level_countout_seconds
	level_countout.one_shot = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	if character_node.player_alive:
		time += delta
		msec = fmod(time, 1) * 100
		seconds = fmod(time, 60)
		minutes = fmod(time, 3600) / 60
	else:
		if !end_level:
			LevelDirector.player_score = (minutes * 60) + seconds
			level_countout.start()
			end_level = true
		else:
			if level_countout.is_stopped() && not change_level:
				change_level = true
				SceneManager.change_scene("res://Scenes/end_level.tscn", SceneManager.TransitionTypes.dissolve)
		
	
	self.text = get_time_formatted() #"%02d:" % minutes
	#$Seconds.text = "%02d." % seconds
	#$Milliseconds.text = "%03d" % msec

func get_time_formatted() -> String:
	return "%02d:%02d.%03d" % [minutes, seconds, msec]
