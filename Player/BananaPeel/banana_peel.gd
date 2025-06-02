extends Area2D

@export var damage = 1
@export var stun_duration = 1.5
@export var lifetime = 240  # desaparece sozinho após isso

signal remove_from_array(object)

func _ready():
	$Timer.start(lifetime)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("enemy"):
		if body.has_method("enemy_hit"):
			body.enemy_hit(damage)

		# Stun simples: desativa movimento do inimigo
		body.slow(stun_duration, 30)
		
		queue_free()

	

func _on_timer_timeout() -> void:
	queue_free()
