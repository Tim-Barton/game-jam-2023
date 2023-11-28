extends StaticBody2D
class_name breakaway

var anim_player : AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	anim_player = $AnimatedSprite2D
	anim_player.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if body is Player:
		anim_player.play("break")
		await anim_player.animation_finished
		self.queue_free()
