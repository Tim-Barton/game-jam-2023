class_name Player
extends CharacterBody2D

# Adjustables
@export var controller : player_controller
@export_group("Physics")
@export var gravity = 1580
@export var max_fall_velocity = 700

@export_group("Speed")
@export var speed = 300.0
@export var acceleration = 0.1
@export var decceleration = 0.2
@export var dodge_time = 0.1
@export var dodge_speed = 700

@export_group("Jump")
@export var jump_force = -500.0
@export var jump_early_release = 0.2

@export var early_jump_allowance = 0.1
@export var coyote_time_allowance = 0.15
@export var max_jumps_enabled = 2
@export var apex_float_modifier = 0.4
@export var apex_threshold = 100

@export_subgroup("Wall Jump")
@export var max_wall_slide_velocity = 100
@export var wall_jump_time = 0.2
@export var wall_jump_x_speed = 700

@export_group("Stamina")
@export var jump_stamina_cost = 5
@export var max_stamina = 100
@export var stamina_regen_rate_idle = 5
@export var stamina_regen_rate_walk = 2
@export var low_stamina_penalty = 0.4
@export var health_stamina_penalty = 0.5

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
var controller_node : Node
var wall_jump_node : Timer

## Enums
enum PlayerStates {Idle, Walk, Jumping, Falling, Landed}

## Input Variables
var input_dict = {
	"left": false,
	"right": false,
	"jump": false,
	"dodge": false,
	"release_control": false
}
var previous_input = {}

## Process Vars
var player_state : PlayerStates
var previous_player_state : PlayerStates
var direction = 0
var character_velocity : Vector2
var was_on_floor : bool
var cur_jump_count = 0
var cur_stamina = 0

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
	
	var new_wall_jump_timer := Timer.new()
	new_wall_jump_timer.name = "wall_jump_time"
	add_child(new_wall_jump_timer)
	
	animation_node = get_node("animations")
	jump_allowance_node = get_node("jump_allowance")
	coyote_node = get_node("coyote_allowance")
	dodge_node = get_node("dodge_time")
	controller_node = get_node("controller_container")
	wall_jump_node = get_node("wall_jump_time")
	
	set_timers()
	
	was_on_floor = is_on_floor()
	sync_input_dicts()
	floor_max_angle = char_slope_angle
	floor_snap_length = char_snap_length
	cur_stamina = max_stamina
	set_controller(human_controller.new(self))

func set_timers():
	jump_allowance_node.wait_time = early_jump_allowance
	jump_allowance_node.one_shot = true
	coyote_node.wait_time = coyote_time_allowance
	coyote_node.one_shot = true
	dodge_node.wait_time = dodge_time
	dodge_node.one_shot = true
	wall_jump_node.wait_time = wall_jump_time
	wall_jump_node.one_shot = true

func set_controller(input_controller: player_controller) -> void:
	#Remove Previous Controllers
	for child in controller_node.get_children():
		child.queue_free()
		
	controller = input_controller
	controller_node.add_child(controller)

func update_animation():
	if is_left:
		animation_node.flip_h = true
	else:
		animation_node.flip_h = false

func sync_input_dicts() -> void:
	for key_input in input_dict.keys():
		previous_input[key_input] = input_dict[key_input]

func is_pressed(input_check: String) -> bool:
	return input_dict[input_check] == true
	
func is_just_pressed(input_check: String) -> bool:
	if input_dict[input_check]:
		if previous_input[input_check] == false:
			return true
	return false
	
func is_just_released(input_check: String) -> bool:
	if !input_dict[input_check]:
		if previous_input[input_check]:
			return true
	return false

func character_jump(increase_jump_count : int, early_release : bool = false) -> float:
	var calc_jump_force = jump_force
	if early_release:
		calc_jump_force *= jump_early_release
	else:
		if cur_stamina < jump_stamina_cost:
			calc_jump_force = calc_jump_force * low_stamina_penalty
		cur_stamina = clamp(cur_stamina-jump_stamina_cost,0,max_stamina)
	
	cur_jump_count += increase_jump_count
	return calc_jump_force

func get_character_input():
	character_velocity.x = velocity.x
	character_velocity.y = velocity.y
	
	# Handle Jump.
	if is_just_released("jump") && velocity.y < 0:
		character_velocity.y = character_jump(0,true)
		
	if is_just_pressed("jump"):
		if not coyote_node.is_stopped():
			character_velocity.y = character_jump(1)
			coyote_node.stop()
		elif is_on_wall() && not is_on_floor():
			character_velocity.y = character_jump(0)
			var wall_jump_velocity = wall_jump_x_speed
			if cur_stamina <= jump_stamina_cost:
				wall_jump_velocity = wall_jump_x_speed * low_stamina_penalty
			if not is_left:
				wall_jump_velocity = wall_jump_velocity * -1
			character_velocity.x = wall_jump_velocity
			wall_jump_node.start()
		elif not is_on_floor() && cur_jump_count < (max_jumps_enabled - 1):
			character_velocity.y = character_jump(1)
			wall_jump_node.stop()
		else:
			jump_allowance_node.start()
		
	if is_on_floor() && not jump_allowance_node.is_stopped():
		character_velocity.y = character_jump(1)
		jump_allowance_node.stop()
	
	# Direction Input
	if (is_pressed("left")):
		direction = -1
	elif (is_pressed("right")):
		direction = 1
	else:
		direction = 0
		
	if direction != 0:
		is_left = (direction == -1)
	
	#Apply Accelerations
	#Both Dodging and wall jumps are set character X speeds while they are in control
	if dodge_node.is_stopped() && wall_jump_node.is_stopped():
		var adjust_rate = acceleration
		if direction != clamp(velocity.x,-1,1):
			adjust_rate = decceleration
			
		var _velocity = velocity.x
		character_velocity.x = lerp(_velocity, direction * speed,adjust_rate)
	
	#Handle Dodge
	if is_just_pressed("dodge"):
		character_velocity.y = 0
		var dodge_velocity = dodge_speed
		if not is_left:
			dodge_velocity = dodge_velocity * -1
		character_velocity.x = dodge_velocity
		dodge_node.start()

func update_player_state():
	if is_on_floor():
		cur_jump_count = 0
		if !was_on_floor:
			player_state = PlayerStates.Landed
		elif direction != 0:
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
	sync_input_dicts()

func update_player_physics(delta):
	if not is_on_floor() and dodge_node.is_stopped():
		var gravity_modifier = 1
		
		if velocity.y < apex_threshold && velocity.y > -(apex_threshold):
			gravity_modifier = apex_float_modifier
		character_velocity.y += gravity * gravity_modifier * delta
	
	if character_velocity.y > 0:
		if is_on_wall():
			character_velocity.y = clamp(character_velocity.y,0,max_wall_slide_velocity)
		else:
			character_velocity.y = clamp(character_velocity.y,0,max_fall_velocity)
	
	velocity.y = character_velocity.y
	velocity.x = character_velocity.x

func _test_only_code() -> void:
	if is_pressed("release_control"):
		input_dict["release_control"] = false
		set_controller(human_controller.new(self))

func player_final(delta : float) -> void:
	if player_state == PlayerStates.Idle:
		cur_stamina = clamp(cur_stamina+stamina_regen_rate_idle*delta,0,max_stamina)
	elif player_state == PlayerStates.Walk:
		cur_stamina = clamp(cur_stamina+stamina_regen_rate_walk*delta,0,max_stamina)
	
func _physics_process(delta):
	get_character_input()
	update_player_physics(delta)
	update_player_state()
	update_animation()
	move_and_slide()
	player_final(delta)
	
	# Coyote Time Check
	if was_on_floor && not is_on_floor() && velocity.y == 0:
		coyote_node.start()
	
	_test_only_code()
	
	final_update()
