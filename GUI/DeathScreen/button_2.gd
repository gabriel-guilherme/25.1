extends Button

func _ready():
	# Conecta o sinal "pressed" ao método _on_button_pressed
	self.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://World/world.tscn")
