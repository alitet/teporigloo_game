extends CharacterBody2D

const UP_DIRECTION = Vector2.UP

@export var speed = 600.0
@export var jump_strenght = 1500.0
@export var maximum_jumps = 2
@export var double_jump_strenght = 1200.0
@export var gravity = 4500.0

var _jumps_made = 0
##var _velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	var _horizontal_direction = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	velocity.x = _horizontal_direction * speed
	velocity.y += gravity * delta
	move_and_slide()
