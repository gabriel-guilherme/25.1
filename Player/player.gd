extends CharacterBody2D

@export var movement_speed = 40.0
@export var hp = 80
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
@export var banana_attackspeed = 1.5
@export var banana_level = 1

# Punch
var punch_ammo = 0
var punch_baseammo = 1
@export var punch_attackspeed = 1.5
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
@onready var soundLevelUp = get_node("%sound_levelup")

#enemy spawner
@onready var enemySpawner = get_node("/root/World/EnemySpawner")

func _ready():
	attack()
	set_expbar(experience, calculate_experiencecap())

func _physics_process(_delta):
	if enemySpawner.enemy_defeated >= enemySpawner.max_enemy_per_wave:
		levelup()
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
		bananaTimer.wait_time = banana_attackspeed
		if bananaTimer.is_stopped():
			bananaTimer.start()

	if punch_level > 0:
		punchTimer.wait_time = punch_attackspeed
		if punchTimer.is_stopped():
			punchTimer.start()

	if banana_peel_level > 0:
		bananaPeelTimer.wait_time = banana_peel_attackspeed
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
		var banana_attack = banana.instantiate()
		banana_attack.position = position
		banana_attack.target = get_random_target_from(enemy_close)
		banana_attack.level = banana_level
		add_child(banana_attack)
		banana_ammo -= 1

		if banana_ammo > 0:
			bananaAttackTimer.start()
		else:
			bananaAttackTimer.stop()

func _on_punch_timer_timeout():
	if enemy_close_punch.size() > 0:
		punch_ammo += punch_baseammo
		punchAttackTimer.start()

func _on_punch_attach_timer_timeout():
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
func _on_hurt_box_hurt(damage: Variant, _angle, _knockback):
	hp -= damage
	print(hp)


func _on_grab_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		area.target = self


func _on_collect_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		var gem_exp = area.collect()
		calculate_experience(gem_exp)

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
	set_expbar(experience, exp_required)

func calculate_experiencecap():
	var exp_cap = experience_level
	if experience_level < 20:
		exp_cap = experience_level * 5
	elif experience_level < 40:
		exp_cap + 95 * (experience_level-19)*8
	else:
		exp_cap = 255 + (experience_level-39)*12
	
	return exp_cap

func set_expbar(set_value = 1, set_max_value = 100):
	expBar.value = set_value
	expBar.max_value = set_max_value

func levelup():
	get_tree().paused = true
	enemySpawner.reset_spawned()
	
	sprite.play("dominance")
	await get_tree().create_timer(0.5).timeout
	
	soundLevelUp.play()
	lbLevel.text = str("Level: ", experience_level)
	var tween = levelPanel.create_tween()
	tween.tween_property(levelPanel, "position", Vector2(220, 50), 0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.play()
	levelPanel.visible = true
	var options = 0
	var optionsmax = 3
	while options < optionsmax:
		var option_choice = itemOptions.instantiate()
		upgradeOptions.add_child(option_choice)
		options += 1
	

func upgrade_character(upgrade):
	var option_children = upgradeOptions.get_children()
	for i in option_children:
		i.queue_free()
	levelPanel.visible = false
	levelPanel.position = Vector2(800, 50)
	get_tree().paused = false
	calculate_experience(0)
	enemySpawner.is_spawning = true
