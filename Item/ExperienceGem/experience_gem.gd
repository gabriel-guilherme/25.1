extends Area2D

@export var experience = 1

var gem_blue = preload("res://Sprites/items/Gem_blue.png")
var gem_green = preload("res://Sprites/items/Gem_green.png")
var gem_red = preload("res://Sprites/items/Gem_red.png")

var target = null
var speed = -.7

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var sound = $AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if experience < 5:
		return
	elif experience < 25:
		sprite.texture = gem_blue
	else:
		sprite.texture = gem_red


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if target != null:
		global_position = global_position.move_toward(target.global_position, speed)
		speed += 2*delta


func collect():
	collision.call_deferred("set", "disabled", true)
	sprite.visible = false
	return experience

func _on_audio_stream_player_2d_finished() -> void:
	queue_free()
