extends CharacterBody2D


@export var movement_speed = 20.0
var base_movement_speed = movement_speed
@export var hp = 20
@export var knockback_recovery = 3.5
@export var experience = 1
var knockback = Vector2.ZERO
var is_stunned = false

@onready var player = get_tree().get_first_node_in_group("player")
@onready var loot_base = get_tree().get_first_node_in_group("loot")
@onready var sprite = $AnimatedSprite2D
@onready var sound_hit = $sound_hit

signal remove_from_array(object)

var exp_gem = preload("res://Item/ExperienceGem/experience_gem.tscn")


func _physics_process(_delta):
	
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	var direction = global_position.direction_to(player.global_position)
	velocity = direction*movement_speed
	
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

func death():
	movement_speed = 0
	sprite.play("disappear")
	await sprite.animation_finished
	
	emit_signal("remove_from_array", self)
	
	var new_gem = exp_gem.instantiate()
	new_gem.global_position = global_position
	new_gem.experience = experience
	loot_base.call_deferred("add_child", new_gem)
	queue_free()

func _on_hurt_box_hurt(damage: Variant, angle, knockback_amount) -> void:
	hp -= damage
	knockback = angle * knockback_amount
	#print("FAÇA A LUZ")
	if hp <= 0:
		death()
		
	else:
		sound_hit.play()
