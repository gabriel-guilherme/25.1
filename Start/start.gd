extends Control

func _on_quit_button_pressed() -> void:
	# fechar o jogo
	get_tree().quit()

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://World/world.tscn")
