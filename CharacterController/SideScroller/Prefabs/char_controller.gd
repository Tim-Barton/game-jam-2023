extends CharacterBody2D

# Adjustables
@export var speed = 300.0
@export var jump_force = -500.0
@export var jump_early_release = 0.2
@export var gravity = 1580
@export var acceleration = 0.1
@export var decceleration = 0.2
@export var early_jump_allowance = 0.1
@export var coyote_time_allowance = 0.15
@export var apex_float_modifier = 0.4
@export var apex_threshold = 100
@export var max_fall_velocity = 700
@export var dodge_time = 0.1
@export var dodge_speed = 700

# Internal Variables
## Presets
var is_left = false
const char_snap_length = 32.0
const char_slope_angle = deg_to_rad(46)

## Internal Nodes
var animation_node : AnimatedSprite2D
var jump_allowance_node : Timer
var coyote_node : Timer
var dodge_node : Timer

## Enums
enum PlayerStates {Idle, Walk, Jumping, Falling}

## Process Vars
var player_state : PlayerStates
var previous_player_state : PlayerStates
var direction = 0
var character_velocity : Vector2
var was_on_floor : bool

func _ready():
	var new_jump_timer := Timer.new()
	new_jump_timer.name = "jump_allowance"
	add_child(new_jump_timer)
	
	var new_coyote_timer := Timer.new()
	new_coyote_timer.name = "coyote_allowance"
	add_child(new_coyote_timer)
	
	var new_dodge_timer := Timer.new()
	new_dodge_timer.name = "dodge_time"
	add_child(new_dodge_timer)
	
	animation_node = get_node("animations")
	jump_allowance_node = get_node("jump_allowance")
	coyote_node = get_node("coyote_allowance")
	dodge_node = get_node("dodge_time")
	
	set_timers()
	
	was_on_floor = is_on_floor()
	
	floor_max_angle = char_slope_angle
	floor_snap_length = char_snap_length

func set_timers():
	jump_allowance_node.wait_time = early_jump_allowance
	jump_allowance_node.one_shot = true
	coyote_node.wait_time = coyote_time_allowance
	coyote_node.one_shot = true
	dodge_node.wait_time = dodge_time
	dodge_node.one_shot = true
	
func update_animation():
	if is_left:
		animation_node.flip_h = true
	else:
		animation_node.flip_h = false

func get_character_input():
	# Handle Jump.
	if Input.is_action_just_released("ui_accept") && velocity.y < 0:
		character_velocity.y = character_velocity.y * jump_early_release
		
	if Input.is_action_just_pressed("ui_accept"):
		if not coyote_node.is_stopped():
			character_velocity.y = jump_force
			coyote_node.stop()
		else:
			jump_allowance_node.start()
		
	if is_on_floor() && not jump_allowance_node.is_stopped():
		character_velocity.y = jump_force
		jump_allowance_node.stop()
	
	# Direction Input
	direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		is_left = (direction == -1)
	
	#Apply Accelerations
	if dodge_node.is_stopped():
		var adjust_rate = acceleration
		if direction != clamp(velocity.x,-1,1):
			adjust_rate = decceleration
			
		var _velocity = velocity.x
		character_velocity.x = lerp(_velocity, direction * speed,adjust_rate)
	
	#Handle Dodge
	if Input.is_action_just_pressed("dodge"):
		character_velocity.y = 0
		var dodge_velocity = dodge_speed
		if not is_left:
			dodge_velocity = dodge_velocity * -1
		character_velocity.x = dodge_velocity
		dodge_node.start()


func update_player_state():
	if is_on_floor():
		if direction != 0:
			player_state = PlayerStates.Walk
		elif direction == 0:
			player_state = PlayerStates.Idle
	else:
		if velocity.y < 0:
			player_state = PlayerStates.Jumping
		else:
			player_state = PlayerStates.Falling
			
	#if player_state != previous_player_state:
	#	print("State Changed = "+str(player_state))
	
func final_update():
	previous_player_state = player_state
	was_on_floor = is_on_floor()

func update_player_physics(delta):
	
	if not is_on_floor() and dodge_node.is_stopped():
		var gravity_modifier = 1
		
		if velocity.y < apex_threshold && velocity.y > -(apex_threshold):
			gravity_modifier = apex_float_modifier
		character_velocity.y += gravity * gravity_modifier * delta
	
	if character_velocity.y > 0:
		character_velocity.y = clamp(character_velocity.y,0,max_fall_velocity)
		
	velocity.y = character_velocity.y
	velocity.x = character_velocity.x
	
func _physics_process(delta):
	character_velocity.x = velocity.x
	character_velocity.y = velocity.y
	
	get_character_input()
	update_player_physics(delta)
	update_player_state()
	update_animation()
	move_and_slide()
	
	# Coyote Time Check
	if was_on_floor && not is_on_floor() && velocity.y == 0:
		coyote_node.start()
	
	final_update()
