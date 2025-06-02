extends Area2D

@export var level = 1
@export var damage = 5
@export var radius = 100.0
@export var angular_speed = 2.0  # Radianos por segundo
@export var index = 0  # Posição relativa (de 0 a n-1 se for parte do cacho)
@export var total_bananas = 3

var angle_offset = 0.0
@onready var player = get_tree().get_first_node_in_group("player")

signal remove_from_array(object)

func _ready():
	match level:
		1:
			damage = 5
			radius = 100.0
			angular_speed = 2.0
		2:
			damage = 8
			radius = 110.0
			angular_speed = 2.5
		3:
			damage = 12
			radius = 120.0
			angular_speed = 3.0
		_:
			damage = 15
			radius = 130.0
			angular_speed = 3.5
	
	if total_bananas > 0:
		angle_offset = (TAU / total_bananas) * index
	update_position()

func _process(delta):
	angle_offset += angular_speed * delta
	update_position()

func update_position():
	if player:
		var new_pos = player.global_position + Vector2.RIGHT.rotated(angle_offset) * radius
		global_position = new_pos

func _on_area_entered(area):
	if area.is_in_group("enemy"):
		if area.has_method("enemy_hit"):
			area.enemy_hit(damage)
