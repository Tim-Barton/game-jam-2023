extends Area2D

func _on_body_entered(body):
	if body is Player:
		body.set_controller(ai_controller.new(body))
