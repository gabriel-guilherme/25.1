extends Area2D

@export var level = 1
@export var hp = 1
@export var speed = 100
@export var wait_time = 1.5
@export var damage = 5
@export var knockback = 100
@export var attack_size = 1.0

var target = Vector2.ZERO
var angle = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")

signal remove_from_array(object)

# Called when the node enters the scene tree for the first time.
func _ready():
	angle = global_position.direction_to(target)
	rotation = angle.angle() + deg_to_rad(100)
	match level:
		1:
			hp = 1
			speed = 100
			damage = 5
			knockback = 100
			attack_size = 1.0 * (1 + player.attack_size)
		2:
			hp = 1
			speed = 300
			damage = 5
			knockback = 200
			attack_size = 1.0 * (1 + player.attack_size)
		3:
			hp = 2
			speed = 300
			damage = 8
			knockback = 200
			attack_size = 2.0 * (1 + player.attack_size)
		4:
			hp = 5
			speed = 400
			damage = 12
			knockback = 300
			attack_size = 2.5 * (1 + player.attack_size)
	
	# Escala o sprite
	$Sprite2D.scale *= attack_size

	# Escala a colisão (ex: se for círculo)
	$CollisionShape2D.shape.extents *= attack_size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += angle*speed*delta


func enemy_hit(charge = 1):
	hp -= charge
	if hp <= 0:
		emit_signal("remove_from_array", self)
		queue_free()


func _on_timer_timeout() -> void:
	emit_signal("remove_from_array", self)
	queue_free()
