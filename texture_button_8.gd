extends TextureButton


func _on_pressed() -> void:
	
	var target_scene = preload("res://LessonOne.tscn")  
	GameState.button_id = "2DArrays"  
	get_tree().change_scene_to_packed(target_scene)
