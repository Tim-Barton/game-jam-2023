extends CanvasModulate
var sceneWind = preload("res://CharacterController/SideScroller/Scenes/wind.tscn")
@export var gradient:GradientTexture1D
@export var INGAME_SPEED = 1.0  # 1 realtime second to take 1 ingame minute, setting to 20 would mean 1 realtime sec would pass 20 in game minutes
@export var INITIAL_HOUR = 12:
	set(h):
		INITIAL_HOUR = h
		time = INGAME_TO_REAL_MINUTE_DURATION * INITIAL_HOUR * MINUTES_PER_HOUR

var time:float = 0.0
var past_minute:float = -1.0
const MINUTES_PER_DAY = 1440
const MINUTES_PER_HOUR = 60
const INGAME_TO_REAL_MINUTE_DURATION = (2 * PI) / MINUTES_PER_DAY

signal time_tick(day:int, hour:int, minute:int)

func _ready():
	time = INGAME_TO_REAL_MINUTE_DURATION * INITIAL_HOUR * MINUTES_PER_HOUR

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta * INGAME_TO_REAL_MINUTE_DURATION * INGAME_SPEED
	
	var value = (sin(time - PI / 2) + 1.0) / 2.0 
	self.color = gradient.gradient.sample(value)
	
	_recalculate_time()
	
func _recalculate_time():
	var total_minutes = int(time / INGAME_TO_REAL_MINUTE_DURATION)
	var day = int(total_minutes / MINUTES_PER_DAY)
	var current_day_minutes = total_minutes % MINUTES_PER_DAY
	var hour = int(current_day_minutes / MINUTES_PER_HOUR)
	var minute = int(current_day_minutes % MINUTES_PER_HOUR)
	
	
	
	if past_minute != minute:
		past_minute = minute
		if hour >= 10 and hour <= 12:
			$Rain.visible = true
		#else:
			#$Rain.visible = false
				
		if hour >= 13 and hour <= 15:
			$Snow.emitting = true
			$Snow.visible = true
		else: 
			$Snow.emitting = false
			#$Snow.visible = false
			
		if hour >= 7 and hour <= 9:
			var instance = sceneWind.instantiate()
			add_child(instance)
			instance.visible = true
			#instance.reverse_direction = false
			#instance.line_segments = 20
			#instance.trail_length = 1.0
			#instance.trail_speed = 0.001
			#instance.random_y_offset = 1.0

			
		#time_tick.emit(day, hour, minute)
		#print("Day: ", day, "Hour: ", hour, "Min: ", minute)


func _on_value_value_changed(value):
	INGAME_SPEED = value

