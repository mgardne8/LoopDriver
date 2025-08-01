extends Control

func _on_Retry_pressed() -> void:
	GlobalController._initiate()
	GlobalController.game_over = false
	get_tree().change_scene_to_file("res://Assets/Scenes/city_level.tscn")
	

func _on_Exit_pressed() -> void:  #change this to a main menu button
	print_debug("Exit")
	get_tree().quit()
