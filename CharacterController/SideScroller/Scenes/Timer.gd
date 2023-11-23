extends Label

var time: float = 0.0
var minutes: int = 0
var seconds: int = 0
var msec: int = 0 



# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#var new_level_countout := Timer.new()
	#new_level_countout.name = "level_countout"
	#add_child(new_level_countout)
	#level_countout = get_node("level_countout")
	#level_countout.wait_time = level_countout_seconds
	#level_countout.one_shot = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	pass
	#if character_node.player_alive:
	#	time += delta
	#	msec = fmod(time, 1) * 100
	#	seconds = fmod(time, 60)
	#	minutes = fmod(time, 3600) / 60
	#else:
		
		
	
	#self.text = get_time_formatted() #"%02d:" % minutes
	#$Seconds.text = "%02d." % seconds
	#$Milliseconds.text = "%03d" % msec


