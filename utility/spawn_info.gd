class_name Spawn_info
extends Resource

@export var enemy: PackedScene
@export var time_start: int
@export var time_end: int
@export var enemy_spawn_delay: int
var spawn_delay_counter: int = 0

# Multiplicadores de progressão
var health_multiplier: float = 1.0
var speed_multiplier: float = 1.0
var damage_multiplier: float = 1.0

func reset():
	spawn_delay_counter = 0
