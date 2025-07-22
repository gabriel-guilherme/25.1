extends Control

# Conecte esses nós pelo editor do Godot
@onready var bananas_label = %bananas_label
@onready var hp_button = %hp_button
@onready var hp_cost_label = %hp_cost_label
@onready var speed_button = %spd_button
@onready var speed_cost_label = %spd_cost_label
@onready var damage_button = %dmg_button
@onready var damage_cost_label = %dmg_cost_label

# Custos base para os upgrades
const HP_BASE_COST = 50
const SPEED_BASE_COST = 75
const DAMAGE_BASE_COST = 100

func _ready() -> void:
	update_ui()

func update_ui() -> void:
	# Atualiza a contagem de bananas
	bananas_label.text = "Bananas: " + str(GameData.progression.bananas)
	
	# Atualiza UI de Vida
	var hp_level = GameData.progression.permanent_health_level
	var hp_cost = HP_BASE_COST * (hp_level + 1) # Custo aumenta com o nível
	hp_cost_label.text = "Nível: %d | Custo: %d" % [hp_level, hp_cost]
	hp_button.disabled = GameData.progression.bananas < hp_cost
	
	# Atualiza UI de Velocidade
	var speed_level = GameData.progression.permanent_speed_level
	var speed_cost = SPEED_BASE_COST * (speed_level + 1)
	speed_cost_label.text = "Nível: %d | Custo: %d" % [speed_level, speed_cost]
	speed_button.disabled = GameData.progression.bananas < speed_cost
	
	# Atualiza UI de Dano
	var damage_level = GameData.progression.permanent_damage_level
	var damage_cost = DAMAGE_BASE_COST * (damage_level + 1)
	damage_cost_label.text = "Nível: %d | Custo: %d" % [damage_level, damage_cost]
	damage_button.disabled = GameData.progression.bananas < damage_cost

func _on_hp_button_pressed() -> void:
	var hp_level = GameData.progression.permanent_health_level
	var cost = HP_BASE_COST * (hp_level + 1)
	
	if GameData.progression.bananas >= cost:
		GameData.progression.bananas -= cost
		GameData.progression.permanent_health_level += 1
		GameData.save_data()
		update_ui()

# Funções para os outros botões de upgrade
func _on_spd_button_pressed() -> void:
	var speed_level = GameData.progression.permanent_speed_level
	var cost = SPEED_BASE_COST * (speed_level + 1)
	
	if GameData.progression.bananas >= cost:
		GameData.progression.bananas -= cost
		GameData.progression.permanent_speed_level += 1
		GameData.save_data()
		update_ui()

func _on_dmg_button_pressed() -> void:
	var damage_level = GameData.progression.permanent_damage_level
	var cost = DAMAGE_BASE_COST * (damage_level + 1)
	
	if GameData.progression.bananas >= cost:
		GameData.progression.bananas -= cost
		GameData.progression.permanent_damage_level += 1
		GameData.save_data()
		update_ui()


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Start/Start.tscn")
