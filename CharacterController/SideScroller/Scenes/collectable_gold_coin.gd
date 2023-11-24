extends StaticBody2D

@export var value = 10

func Collect():
	queue_free()
	LevelDirector.yellow_coins += 1
