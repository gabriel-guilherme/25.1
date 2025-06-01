extends CharacterBody2D


@export var movement_speed = 40.0
@onready var sprite = $Sprite2D


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
