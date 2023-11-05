extends Control

var CharacterController

# Called when the node enters the scene tree for the first time.
func _ready():
	CharacterController = $"../Level/Character"

func _unhandled_input(event):
	grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func UpdateCharacterRate(NewValue : float, Adjuster : String):
	match Adjuster:
		"JumpForce":
			CharacterController.jump_force = (NewValue*-1)
		"Speed":
			CharacterController.speed = NewValue
		"JumpRelease":
			CharacterController.jump_early_release = NewValue/10
		"Gravity":
			CharacterController.gravity = NewValue
		"Acceleration":
			CharacterController.acceleration = NewValue/900
		"Decceleration":
			CharacterController.decceleration = NewValue/900
		"EarlyJump":
			CharacterController.early_jump_allowance = NewValue/10
			CharacterController.set_timers()
		"Coyote":
			CharacterController.coyote_time_allowance = NewValue/100
			CharacterController.set_timers()
		"ApexFloat":
			CharacterController.apex_float_modifier = NewValue/10
		"ApexThreshold":
			CharacterController.apex_threshold = NewValue/10
		"MaxFallSpeed":
			CharacterController.max_fall_velocity = NewValue
		"DodgeTime":
			CharacterController.dodge_time = NewValue
			CharacterController.set_timers()
		"DodgeSpeed":
			CharacterController.dodge_speed = NewValue
	grab_focus()
