extends Area2D

@export var heal_amount = 10  # Quantidade de vida que essa gema cura

var target = null
var speed = -0.7

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var sound = $AudioStreamPlayer2D


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	if target != null:
		global_position = global_position.move_toward(target.global_position, speed)
		speed += 2 * delta


func collect():
	# Desativa a colisão e oculta o sprite
	collision.call_deferred("set", "disabled", true)
	sprite.visible = false

	# Aplica a cura ao jogador
	#if player.has_method("heal"):
	#	player.heal(heal_amount)
	sound.play()
	return heal_amount

	


func _on_audio_stream_player_2d_finished() -> void:
	queue_free()
