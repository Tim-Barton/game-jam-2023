extends Node2D


func _input(event):
	if Input.is_action_just_pressed("click"):
		var mouse_pos : Vector2 = get_global_mouse_position()
		LevelDirector.DebugMessage("X:"+str(mouse_pos.x)+" Y:"+str(mouse_pos.y))
		for i in range(1):
			var td_1 = World.get_custom_data_by_id(mouse_pos,0)
			LevelDirector.DebugMessage("Layer: "+str(i)+" "+str(td_1))
