class_name MovementCommand
extends Command

class Params:
	var input: String
	var buttondown : bool
	
	func _init(input : String, buttondown: bool) -> void:
		self.input = input
		self.buttondown = buttondown
		
func execute(player: Player, data: Object = null) -> void:
	if data is Params:
		player.input_dict[data.input] = data.buttondown
