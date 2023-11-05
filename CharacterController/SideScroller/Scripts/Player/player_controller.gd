class_name player_controller
extends Node


var player: Player

var movement_command := MovementCommand.new()

func _init(in_player: Player) -> void:
	self.player = in_player
