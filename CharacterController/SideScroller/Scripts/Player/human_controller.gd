class_name human_controller
extends player_controller

var key_inputs = {
	"ui_accept": "jump",
	"dash": "dash",
	"ui_left": "left",
	"ui_right": "right",
	"fly":"fly",
	}

func _physics_process(delta) -> void:
	for key_input in key_inputs.keys():
		if Input.is_action_just_pressed(key_input):
			var key_up = key_inputs[key_input]
			movement_command.execute(player, MovementCommand.Params.new(key_up,true))
		if Input.is_action_just_released(key_input):
			var key_down = key_inputs[key_input]
			movement_command.execute(player, MovementCommand.Params.new(key_down,false))
		
