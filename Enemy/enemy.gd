extends CharacterBody2D

@export var movement_speed = 50.0
var base_movement_speed = movement_speed
@export var hp = 5
@export var knockback_recovery = 3.5
@export var experience = 1
var knockback = Vector2.ZERO
var is_stunned = false

signal enemy_died
signal remove_from_array(object)

@onready var player = get_tree().get_first_node_in_group("player")
@onready var loot_base = get_tree().get_first_node_in_group("loot")
@onready var sprite = $AnimatedSprite2D
@onready var sound_hit = $sound_hit
@onready var enemySpawner = get_node("/root/World/EnemySpawner")

var exp_gem = preload("res://Item/ExperienceGem/experience_gem.tscn")
var is_dead = false

# Propriedades base (para escalonamento)
var base_hp = hp
var current_damage := 0  # Ainda não usado, mas pronto para aplicar
var base_damage := 10  # Valor genérico, pode ser usado em ataques

func _ready():
	# Salva o HP base para uso futuro (caso esteja usando o valor exportado em múltiplos inimigos diferentes)
	pass

func _physics_process(_delta):
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * movement_speed
	velocity += knockback
	move_and_slide()

	if direction.x < 0.1:
		sprite.flip_h = true
	elif direction.x > -0.1:
		sprite.flip_h = false

func slow(duration, power):
	var old_movespeed = base_movement_speed
	if movement_speed - power < 0:
		movement_speed = 0
	else:
		movement_speed -= power
	await get_tree().create_timer(duration).timeout
	movement_speed = old_movespeed

var life_gem = preload("res://Item/LifeGem/life_gem.tscn")

func death():
	if is_dead:
		return
	is_dead = true

	# Spawna gem de vida com 10% de chance
	if randi() % 10 == 0:
		var life = life_gem.instantiate()
		life.global_position = global_position
		loot_base.call_deferred("add_child", life)

	enemySpawner.increase_defeated()
	movement_speed = 0
	sprite.play("disappear")
	await sprite.animation_finished
	emit_signal("remove_from_array", self)
	emit_signal("enemy_died")
	queue_free()

func _on_hurt_box_hurt(damage: int, angle: Vector2, knockback_amount: float) -> void:
	if is_dead:
		return
		
	print(hp, damage, "MAMA")
	hp -= damage
	knockback = angle * knockback_amount

	if hp <= 0:
		death()
	else:
		sound_hit.play()

#  Recebe multiplicadores do WaveManager
func apply_modifiers(h_mul: float, s_mul: float, d_mul: float):
	hp = int(base_hp * h_mul)
	movement_speed = base_movement_speed * s_mul
	current_damage = base_damage * d_mul

	print("Inimigo modificado - HP: %d | Vel: %.2f | Dano: %.2f" % [hp, movement_speed, current_damage])
