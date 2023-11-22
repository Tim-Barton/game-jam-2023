extends Area2D

func _on_body_entered(body):
	if body is Player:
		body.player_alive = false
	#TODO: Calculate numeric score and player name
	SilentWolf.Scores.save_score("test", 100)
