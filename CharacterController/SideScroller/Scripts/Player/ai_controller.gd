class_name ai_controller
extends player_controller

var key_inputs = {
	"ui_accept": "jump",
	"dodge": "dodge",
	"ui_left": "left",
	"ui_right": "right"}

var _init_time : int = 0

func _ready():
	_init_time = Time.get_ticks_msec()

func _physics_process(delta) -> void:
	var current_time = Time.get_ticks_msec() - _init_time
	
	if current_time < 2000:
		movement_command.execute(player, MovementCommand.Params.new("left",true))
	elif current_time < 2300:
		movement_command.execute(player, MovementCommand.Params.new("left",false))
		movement_command.execute(player, MovementCommand.Params.new("right",true))
	elif current_time < 2600:
		movement_command.execute(player, MovementCommand.Params.new("right",false))
		movement_command.execute(player, MovementCommand.Params.new("jump",true))
	elif current_time < 2700:
		movement_command.execute(player, MovementCommand.Params.new("jump",false))
		movement_command.execute(player, MovementCommand.Params.new("dodge",true))
	else:
		movement_command.execute(player, MovementCommand.Params.new("dodge",false))
		movement_command.execute(player, MovementCommand.Params.new("release_control",true))

