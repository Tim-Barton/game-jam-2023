extends RigidBody2D

var ChkGround : RayCast2D
var ChkGround2 : RayCast2D
var ChkGround3 : RayCast2D

var TmrBounce : Timer
var CShape : CollisionShape2D
var DParticle : GPUParticles2D
var apply_countdown_max : int = 100
var current_countdown : int = 0

var bool_hit_floor : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	ChkGround = $CheckGround
	ChkGround2 = $CheckGround2
	ChkGround3 = $CheckGround3
	TmrBounce = $Bouncetimer
	CShape = $CollisionShape2D
	DParticle = $DropParticle
	CShape.disabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	#ChkGround.look_at(Vector2.DOWN)
	
	if CheckHitting():
		if !bool_hit_floor:
			HitSomething()
	else:
		if bool_hit_floor and current_countdown == 0:
			bool_hit_floor = false
		
	if current_countdown > 0:
		freeze = true
		freeze = false
		apply_central_impulse(Vector2(0,-280))
		current_countdown =-1
	
	if TmrBounce.is_stopped():
		if CShape.disabled and not CheckHitting():
			bool_hit_floor = false
			DParticle.restart()
			CShape.disabled = false
		CShape.disabled = false
	else:
		CShape.disabled = true

func CheckHitting() -> bool:
	if ChkGround2.is_colliding() or ChkGround.is_colliding() or ChkGround3.is_colliding():
		return true
	return false
	
func HitSomething() -> void:
	current_countdown = apply_countdown_max
	TmrBounce.start()
	DParticle.emitting = true
	bool_hit_floor = true
	LevelDirector.PlaySound(LevelDirector.HIT)
	LevelDirector.CameraDirector.shake_screen()
	

func _on_area_2d_body_entered(body):
	if body is Player:
		body.stamina_penalty(body.cur_stamina/2)
		HitSomething()
		
func _on_life_timeout():
	queue_free()
