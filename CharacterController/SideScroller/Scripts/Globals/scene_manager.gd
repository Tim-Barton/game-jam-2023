extends CanvasLayer

enum TransitionTypes {dissolve, bluewave}
var Transitioning : bool = false

func change_scene(target: String, transition_type: TransitionTypes) -> void:
	if not Transitioning:
		LevelDirector.PlaySound(LevelDirector.SCENECHANGE)
		match transition_type:
			TransitionTypes.dissolve:
				Transitioning = true
				$AnimationPlayer.play("dissolve")
				await $AnimationPlayer.animation_finished
				get_tree().change_scene_to_file(target)
				$AnimationPlayer.play("dissolve_out")
				Transitioning = false
			TransitionTypes.bluewave:
				Transitioning = true
				$AnimationPlayer.play("blue_wave")
				await $AnimationPlayer.animation_finished
				get_tree().change_scene_to_file(target)
				$AnimationPlayer.play("blue_wave_out")
				Transitioning = false
			_:
				pass
