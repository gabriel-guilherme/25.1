extends Node2D

@export var spawns: Array[Spawn_info] = []
@export var base_max_enemy_per_wave = 5
var max_enemy_per_wave = base_max_enemy_per_wave

var current_wave = 0
var completed_waves = 0
var enemy_spawned = 0
var enemy_defeated = 0
var is_spawning = true
var time = 0

@onready var player = get_tree().get_first_node_in_group("player")


func _on_timer_timeout() -> void:
	time += 1
	if not is_spawning or spawns.is_empty():
		return

	var wave_info = spawns[current_wave]

	if time < wave_info.time_start or time > wave_info.time_end:
		return

	# Incrementa contador de delay
	if wave_info.spawn_delay_counter < wave_info.enemy_spawn_delay:
		wave_info.spawn_delay_counter += 1
	else:
		# Reset contador de delay
		wave_info.spawn_delay_counter = 0

		# --- BLOCO MODIFICADO ---
		# Spawnar uma "rajada" (burst) de inimigos de uma vez
		for i in range(wave_info.enemies_per_burst):
			# Para de spawnar se atingir o máximo da wave
			if enemy_spawned >= max_enemy_per_wave:
				break # Interrompe o loop 'for'

			var enemy_instance = wave_info.enemy.instantiate()
			enemy_instance.global_position = get_random_position()

			if enemy_instance.has_method("apply_modifiers"):
				enemy_instance.apply_modifiers(
					wave_info.health_multiplier,
					wave_info.speed_multiplier,
					wave_info.damage_multiplier
				)

			add_child(enemy_instance)
			enemy_spawned += 1
			print("Spawnou inimigo #%d na wave %d" % [enemy_spawned, current_wave])
		# --- FIM DO BLOCO MODIFICADO ---

		# Se já spawnou tudo, para de spawnar
		if enemy_spawned >= max_enemy_per_wave:
			is_spawning = false


func increase_defeated():
	if enemy_spawned == 0:
		return

	enemy_defeated += 1
	print("Derrotados: %d de %d" % [enemy_defeated, enemy_spawned])
	player.update_wave_progress(enemy_defeated, max_enemy_per_wave)

	if enemy_defeated >= max_enemy_per_wave:
		enemy_spawned = 0
		enemy_defeated = 0
		is_spawning = true
		player.update_wave_progress(0, max_enemy_per_wave)

		player.levelup()
		completed_waves += 1

		var wave_info = spawns[current_wave]
		wave_info.health_multiplier += 0.2
		wave_info.speed_multiplier += 0.1
		wave_info.damage_multiplier += 0.15
		
		# --- BLOCO ADICIONADO ---
		# Aumenta a quantidade de inimigos por rajada na próxima wave
		# Exemplo: Aumenta a cada 2 waves completas para não ser tão rápido
		if completed_waves % 2 == 0:
			wave_info.enemies_per_burst += 1
		
		# Limita o valor máximo para evitar problemas de performance
		wave_info.enemies_per_burst = min(wave_info.enemies_per_burst, 15)
		# --- FIM DO BLOCO ADICIONADO ---

		# Aumenta o número máximo de inimigos na próxima wave
		max_enemy_per_wave += 5

		# --- LINHA MODIFICADA ---
		print("Wave %d - HP x%.2f | SPD x%.2f | DMG x%.2f | Max Enemies: %d | Burst: %d" % [
			current_wave,
			wave_info.health_multiplier,
			wave_info.speed_multiplier,
			wave_info.damage_multiplier,
			max_enemy_per_wave,
			wave_info.enemies_per_burst # Adicionado para debug
		])

		current_wave += 1
		if current_wave >= spawns.size():
			current_wave = 0

		spawns[current_wave].reset()
		print("Nova wave: %d" % current_wave)


func get_random_position() -> Vector2:
	var vpr = get_viewport_rect().size * randf_range(1.1, 1.4)
	var top_left = Vector2(player.global_position.x - vpr.x / 2, player.global_position.y - vpr.y / 2)
	var top_right = Vector2(player.global_position.x + vpr.x / 2, player.global_position.y - vpr.y / 2)
	var bottom_left = Vector2(player.global_position.x - vpr.x / 2, player.global_position.y + vpr.y / 2)
	var bottom_right = Vector2(player.global_position.x + vpr.x / 2, player.global_position.y + vpr.y / 2)

	var pos_side = ["up", "down", "right", "left"].pick_random()
	var spawn_pos1 = Vector2.ZERO
	var spawn_pos2 = Vector2.ZERO

	match pos_side:
		"up":
			spawn_pos1 = top_left
			spawn_pos2 = top_right
		"down":
			spawn_pos1 = bottom_left
			spawn_pos2 = bottom_right
		"right":
			spawn_pos1 = top_right
			spawn_pos2 = bottom_right
		"left":
			spawn_pos1 = top_left
			spawn_pos2 = bottom_left

	var x_spawn = randf_range(spawn_pos1.x, spawn_pos2.x)
	var y_spawn = randf_range(spawn_pos1.y, spawn_pos2.y)
	return Vector2(x_spawn, y_spawn)
