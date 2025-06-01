extends CharacterBody2D


@export var movement_speed = 40.0
@export var hp = 80
@onready var sprite = $Sprite2D

#Attacks
var banana = preload("res://Player/Attack/banana.tscn")

#AttackNodes
@onready var bananaTimer = get_node("%BananaTimer")
@onready var bananaAttackTimer = get_node("%BananaAttachTimer")

#Banana
var banana_ammo = 0
var banana_baseammo = 1
@export var banana_attackspeed = 1.5
var banana_level = 1

#Enemy
var enemy_close = []

func _ready() -> void:
	attack()

func _physics_process(delta: float) -> void:
	movement()

func movement():
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_mov, y_mov)
	
	if mov.x < 0:
		sprite.flip_h = true
	elif mov.x > 0:
		sprite.flip_h = false
	
	velocity = mov.normalized()*movement_speed
	move_and_slide()

func attack():
	if banana_level > 0:
		bananaTimer.wait_time = banana_attackspeed
		if bananaTimer.is_stopped():
			bananaTimer.start()

func _on_hurt_box_hurt(damage: Variant, angle, knockback) -> void:
	hp -= damage
	print(hp)


func _on_banana_timer_timeout() -> void:
	banana_ammo += banana_baseammo
	bananaAttackTimer.start()


func _on_banana_attach_timer_timeout() -> void:
	if banana_ammo > 0:
		var banana_attack = banana.instantiate()
		banana_attack.position = position
		banana_attack.target = get_random_target()
		banana_attack.level = banana_level
		add_child(banana_attack)
		banana_ammo -= 1
		if banana_ammo > 0:
			bananaAttackTimer.start()
		else:
			bananaAttackTimer.stop()

func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP

func _on_enemy_detection_body_entered(body: Node2D) -> void:
	if not enemy_close.has(body):
		enemy_close.append(body)


func _on_enemy_detection_body_exited(body: Node2D) -> void:
	if enemy_close.has(body):
		enemy_close.erase(body)
