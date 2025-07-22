extends Node2D

@onready var enemy_spawner = $EnemySpawner
var bonus_por_wave = 5 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func game_over():
	# Calcula as bananas ganhas (ex: 10 bananas por wave)
	print(enemy_spawner)
	var waves_survived = enemy_spawner.completed_waves
	var multiplicador_dinamico = 10 + (waves_survived * bonus_por_wave)
	var bananas_earned = waves_survived * multiplicador_dinamico  # Você pode ajustar essa fórmula
	
	print("O jogador sobreviveu %d waves e ganhou %d bananas." % [waves_survived, bananas_earned])
	
	# Adiciona as bananas ao total e salva
	GameData.progression.bananas += bananas_earned
	GameData.save_data()
	
	# Continua para a tela de morte
	get_tree().change_scene_to_file("res://GUI/DeathScreen/death_screen.tscn")
