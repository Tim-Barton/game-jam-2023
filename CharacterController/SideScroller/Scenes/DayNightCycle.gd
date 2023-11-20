extends CanvasModulate

@export var gradient:GradientTexture1D
@export var INGAME_SPEED = 1.0  # 1 realtime second to take 1 ingame minute, setting to 20 would mean 1 realtime sec would pass 20 in game minutes
@export var INITIAL_HOUR = 12:
	set(h):
		INITIAL_HOUR = h
		time = INGAME_TO_REAL_MINUTE_DURATION * INITIAL_HOUR * MINUTES_PER_HOUR

var time:float = 0.0
const MINUTES_PER_DAY = 1440
const MINUTES_PER_HOUR = 60
const INGAME_TO_REAL_MINUTE_DURATION = (2 * PI) / MINUTES_PER_DAY

func _ready():
	time = INGAME_TO_REAL_MINUTE_DURATION * INITIAL_HOUR * MINUTES_PER_HOUR

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta * INGAME_TO_REAL_MINUTE_DURATION * INGAME_SPEED
	var value = (sin(time - PI / 2) + 1.0) / 2.0 
	self.color = gradient.gradient.sample(value)
	


func _on_value_value_changed(value):
	INGAME_SPEED = value
	print(INGAME_SPEED)
