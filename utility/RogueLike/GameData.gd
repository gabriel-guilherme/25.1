# GameData.gd
extends Node

const SAVE_PATH = "user://meta_data.tres"
var progression: MetaProgression

func _ready() -> void:
	print("A pasta de save está em: ", OS.get_user_data_dir()) 
	load_data()

func load_data() -> void:
	if ResourceLoader.exists(SAVE_PATH):
		progression = ResourceLoader.load(SAVE_PATH)
	else:
		# Se não existir um save, cria um novo
		progression = MetaProgression.new()
	print("Dados carregados. Bananas: ", progression.bananas)

func save_data() -> void:
	ResourceSaver.save(progression, SAVE_PATH)
	print("Dados salvos. Bananas: ", progression.bananas)
