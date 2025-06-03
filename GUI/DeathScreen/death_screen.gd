extends Control



func _on_retry_button_pressed() -> void:
	#get_tree().paused = false
	get_tree().change_scene_to_file("res://World/world.tscn")


func _on_giveup_button_pressed() -> void:
	#get_tree().paused = false
	get_tree().change_scene_to_file("res://Start/Start.tscn")
