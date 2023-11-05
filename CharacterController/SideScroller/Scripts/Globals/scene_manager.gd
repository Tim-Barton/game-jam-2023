extends CanvasLayer

enum TransitionTypes {dissolve, bluewave}

func change_scene(target: String, transition_type: TransitionTypes) -> void:
	match transition_type:
		TransitionTypes.dissolve:
			$AnimationPlayer.play("dissolve")
			await $AnimationPlayer.animation_finished
			get_tree().change_scene_to_file(target)
			$AnimationPlayer.play_backwards("dissolve")
		TransitionTypes.bluewave:
			$AnimationPlayer.play("blue_wave")
			await $AnimationPlayer.animation_finished
			get_tree().change_scene_to_file(target)
			$AnimationPlayer.play("blue_wave_out")
		_:
			pass
