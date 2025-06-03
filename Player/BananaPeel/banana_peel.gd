extends Area2D

@export var damage = 1
@export var slow_duration = 1.5
@export var lifetime = 240  # desaparece sozinho após isso
var level: int = 1  # definido pelo Player ao instanciar

#signal remove_from_array(object)

func _ready():
	# Ajusta valores com base no nível
	match level:
		1:
			slow_duration = 1.5
		2:
			slow_duration = 2.0
		3:
			slow_duration = 2.5
		4:
			slow_duration = 3.0
	
	$Timer.start(lifetime)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("enemy"):
		if body.has_method("enemy_hit"):
			body.enemy_hit(damage)

		var slow_amount = 30
		match level:
			1:
				slow_amount = 30
			2:
				slow_amount = 40
			3:
				slow_amount = 55
			4:
				slow_amount = 70

		if body.has_method("slow"):
			body.slow(slow_duration, slow_amount)

		queue_free()

func _on_timer_timeout() -> void:
	queue_free()
