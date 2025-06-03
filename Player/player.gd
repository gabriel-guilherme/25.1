extends CharacterBody2D

@export var movement_speed = 30.0
@export var hp = 80
var maxHp = 80
var attack_cooldown = 0
var attack_size = 0
@onready var sprite = $AnimatedSprite2D


var experience = 0
var experience_level = 1
var collected_experience = 0

# Attacks
var banana = preload("res://Player/Attack/banana.tscn")
var punch = preload("res://Player/Attack/punch.tscn")
var banana_peel = preload("res://Player/BananaPeel/banana_peel.tscn")
var banana_orbit_scene = preload("res://Player/BananaOrbit/banana_orbit.tscn")

# Attack Nodes
@onready var bananaTimer = %BananaTimer
@onready var bananaAttackTimer = %BananaAttachTimer
@onready var punchTimer = %PunchTimer
@onready var punchAttackTimer = %PunchAttachTimer
@onready var bananaPeelTimer = %BananaPeelTimer
#@onready var bananaOrbitTimer = %BananaOrbitTimer

# Banana
var banana_ammo = 1
var banana_baseammo = 1
@export var banana_attackspeed = .3
@export var banana_level = 1

# Punch
var punch_ammo = 1
var punch_baseammo = 0
@export var punch_attackspeed = 0.5
@export var punch_level = 0

# Banana Peel
@export var banana_peel_attackspeed = 4.0
@export var banana_peel_level = 0

# Banana Orbit
@export var banana_orbit_level = 0
var has_spawned_orbit = false

# Enemies
var enemy_close = []
var enemy_close_punch = []

#GUI
@onready var expBar = get_node("%ExperienceBar")
@onready var lbLevel = get_node("%lvl_label")
@onready var levelPanel = get_node("%LevelUp")
@onready var upgradeOptions = get_node("%UpgradeOptions")
@onready var itemOptions = preload("res://utility/item_option.tscn")
@onready var soundLevelUp = get_node("%levelup_sound")

#
#@onready var gameOverScreen = get_node("/root/World/GameOverScreen")
#@onready var restartButton = gameOverScreen.get_node("%RestartButton")
#@onready var mainMenuButton = gameOverScreen.get_node("%MainMenuButton")


#UPGRADES
var collected_upgrades = []
var upgrade_options = []
var armor = 0
var speed = 0
var spell_size = 0

#enemy spawner
@onready var enemySpawner = get_node("/root/World/EnemySpawner")
@onready var health_bar = get_node("%HealthBar")

var wave = 1

func _ready():
	update_health_bar()
	attack()
	#set_expbar(experience, calculate_experiencecap())

func _physics_process(_delta):
	#if enemySpawner.enemy_defeated >= enemySpawner.max_enemy_per_wave:
	#	levelup()
	movement()

func movement():
	var mov = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)

	if mov.x < 0:
		sprite.flip_h = true
	elif mov.x > 0:
		sprite.flip_h = false

	if mov.length() > 0:
		if sprite.animation != "walk":
			sprite.play("walk")
	else:
		if sprite.animation != "idle":
			sprite.play("idle")

	velocity = mov.normalized() * movement_speed
	move_and_slide()

func attack():
	if banana_level > 0:
		bananaTimer.wait_time = banana_attackspeed * (1-attack_cooldown)
		if bananaTimer.is_stopped():
			bananaTimer.start()

	if punch_level > 0:
		punchTimer.wait_time = punch_attackspeed * (1-attack_cooldown)
		if punchTimer.is_stopped():
			punchTimer.start()

	if banana_peel_level > 0:
		bananaPeelTimer.wait_time = banana_peel_attackspeed * (1-attack_cooldown)
		if bananaPeelTimer.is_stopped():
			bananaPeelTimer.start()

	if banana_orbit_level > 0 and not has_spawned_orbit:
		spawn_banana_orbit()
		has_spawned_orbit = true

# ========== ATTACK LOGIC ==========

func _on_banana_timer_timeout():
	banana_ammo += banana_baseammo
	bananaAttackTimer.start()

func _on_banana_attach_timer_timeout():
	if banana_ammo > 0:
		for i in range(banana_ammo):
			var banana_attack = banana.instantiate()
			banana_attack.position = position
			banana_attack.target = get_random_target_from(enemy_close)
			banana_attack.level = banana_level
			add_child(banana_attack)
		
		banana_ammo = 0
	bananaAttackTimer.stop()

func _on_punch_timer_timeout():
	print("PunchTimer timeout - adding ammo")
	if enemy_close_punch.size() > 0:
		punch_ammo += punch_baseammo
		punchAttackTimer.start()

func _on_punch_attach_timer_timeout():
	print("PunchAttackTimer timeout - ammo:", punch_ammo)
	if punch_ammo > 0 and enemy_close_punch.size() > 0:
		var punch_attack = punch.instantiate()
		punch_attack.position = position
		punch_attack.target = get_random_target_from(enemy_close_punch)
		punch_attack.level = punch_level
		add_child(punch_attack)
		punch_ammo -= 1

		if punch_ammo > 0:
			punchAttackTimer.start()
		else:
			punchAttackTimer.stop()

func _on_banana_peel_timer_timeout():
	drop_banana_peel()

func spawn_banana_orbit():
	var total = 5
	for i in range(total):
		var orbit = banana_orbit_scene.instantiate()
		orbit.index = i
		orbit.total_bananas = total
		orbit.level = banana_orbit_level
		orbit.player = self  # passa referência do player
		get_parent().call_deferred("add_child", orbit)

func drop_banana_peel():
	var peel = banana_peel.instantiate()
	peel.global_position = global_position
	get_parent().add_child(peel)

# ========== ENEMY DETECTION ==========

func get_random_target_from(list: Array) -> Vector2:
	if list.size() > 0:
		return list.pick_random().global_position
	return Vector2.UP

func _on_enemy_detection_body_entered(body: Node2D):
	if not enemy_close.has(body):
		enemy_close.append(body)

func _on_enemy_detection_body_exited(body: Node2D):
	if enemy_close.has(body):
		enemy_close.erase(body)

func _on_enemy_detection_2_body_entered(body: Node2D):
	if not enemy_close_punch.has(body):
		enemy_close_punch.append(body)

func _on_enemy_detection_2_body_exited(body: Node2D):
	if enemy_close_punch.has(body):
		enemy_close_punch.erase(body)

# ========== DAMAGE ==========
func update_health_bar():
	if health_bar:
		health_bar.max_value = maxHp
		health_bar.value = hp

func _on_hurt_box_hurt(damage: Variant, _angle, _knockback):
	hp -= clamp(damage - armor, 1.0, 999.0)
	update_health_bar()
	print(hp)
	
	if hp <= 0:
		die()

func _change_to_death_scene():
	get_tree().change_scene_to_file("res://GUI/DeathScreen/death_screen.tscn")

func die():
	call_deferred("_change_to_death_scene")
	#get_tree().paused = true
	#gameOverScreen.visible = true

	#restartButton.pressed.connect(restart_game)
	#mainMenuButton.pressed.connect(go_to_menu)

func restart_game():
	get_tree().paused = false
	get_tree().reload_current_scene()

func go_to_menu():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _on_grab_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		area.target = self


func _on_collect_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		hp += area.collect()
		hp = clamp(hp, 0, maxHp)
		update_health_bar()
		#calculate_experience(gem_exp)

func calculate_experience(gem_exp):
	var exp_required = calculate_experiencecap()
	collected_experience += gem_exp
	if experience + collected_experience >= exp_required: #lvl up
		collected_experience -= exp_required - experience
		experience_level += 1
		print("Level:", experience_level)
		
		experience = 0
		exp_required = calculate_experiencecap()
		# levelup()

	else:
		experience += collected_experience
		collected_experience = 0
	#set_expbar(experience, exp_required)

func calculate_experiencecap():
	var exp_cap = experience_level
	if experience_level < 20:
		exp_cap = experience_level * 5
	elif experience_level < 40:
		exp_cap = 95 * (experience_level-19)*8
	else:
		exp_cap = 255 + (experience_level-39)*12
	
	return exp_cap

#func set_expbar(set_value = 1, set_max_value = 100):
#	expBar.value = set_value
#	expBar.max_value = set_max_value
func update_wave_progress(derrotados: int):
	expBar.value = derrotados
	expBar.max_value = 25
	
func levelup():
	get_tree().paused = true
	#enemySpawner.reset_spawned()
	
	
	sprite.play("dominance")
	await get_tree().create_timer(0.5).timeout
	
	soundLevelUp.play()
	wave += 1
	lbLevel.text = str("Wave: ", wave)
	var tween = levelPanel.create_tween()
	tween.tween_property(levelPanel, "position", Vector2(220, 50), 0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.play()
	levelPanel.visible = true
	var options = 0
	var optionsmax = 3
	while options < optionsmax:
		var option_choice = itemOptions.instantiate()
		option_choice.item = get_random_item()
		upgradeOptions.add_child(option_choice)
		options += 1
	

func upgrade_character(upgrade):
	match upgrade:
		# Banana throw
		"banana1":
			banana_level = 1
			banana_baseammo += 1
		"banana2":
			banana_level = 2
			banana_baseammo += 1
		"banana3":
			banana_level = 3
			banana_baseammo += 1
		"banana4":
			banana_level = 4
			banana_baseammo += 1
		
		# Punch
		"punch1":
			punch_level = 1
			punch_baseammo += 1
		"punch2":
			punch_level = 2
			punch_baseammo += 1
		"punch3":
			punch_level = 3
			punch_baseammo += 1
		"punch4":
			punch_level = 4
			punch_baseammo += 1

		# Banana peel
		"banana_peel1":
			#print("aBABAwd")
			banana_peel_level = 1
		"banana_peel2":
			banana_peel_level = 2
		"banana_peel3":
			banana_peel_level = 3
		"banana_peel4":
			banana_peel_level = 4

		# Banana orbit
		"banana_orbit1":
			banana_orbit_level = 1
			has_spawned_orbit = false
		"banana_orbit2":
			banana_orbit_level = 2
			has_spawned_orbit = false
		"banana_orbit3":
			banana_orbit_level = 3
			has_spawned_orbit = false
		"banana_orbit4":
			banana_orbit_level = 4
			has_spawned_orbit = false

		# Outros upgrades
		"medic_kit":
			hp += 20
			hp = clamp(hp, 0, maxHp)
			update_health_bar()
		"coffee1", "coffee2", "coffee3", "coffee4":
			attack_cooldown += 0.05
		"apple1", "apple2", "apple3", "apple4":
			movement_speed += 0.20
		"whey1", "whey2", "whey3", "whey4":
			attack_size += 0.10
		"fur1", "fur2", "fur3", "fur4":
			armor += 1
	
	
	
	
	var option_children = upgradeOptions.get_children()
	for i in option_children:
		i.queue_free()
	upgrade_options.clear()
	collected_upgrades.append(upgrade)
	levelPanel.visible = false
	levelPanel.position = Vector2(800, 50)
	get_tree().paused = false
	calculate_experience(0)

	
	attack()

func get_random_item():
	var dblist = []
	for i in UpgradeDb.UPGRADES:
		if i in collected_upgrades: #find already collected upgrades
			pass
		elif i in upgrade_options:
			pass
		elif UpgradeDb.UPGRADES[i]["type"] == "item":
			pass
		elif UpgradeDb.UPGRADES[i]["prerequesite"].size() > 0 :
			for n in UpgradeDb.UPGRADES[i]["prerequesite"]:
				if not n in collected_upgrades:
					pass
				else:
					dblist.append(i)
		else:
			dblist.append(i)
	enemySpawner.is_spawning = true
	if dblist.size() > 0:
		var randomitem = dblist.pick_random()
		upgrade_options.append(randomitem)
		return randomitem
	else:
		return null

  
	enemySpawner.is_spawning = true
