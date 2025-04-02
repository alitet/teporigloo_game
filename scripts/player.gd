extends CharacterBody2D

const UP_DIRECTION = Vector2.UP

@export var speed = 600.0
@export var jump_strenght = 1500.0
@export var maximum_jumps = 2
@export var double_jump_strenght = 1200.0
@export var gravity = 4500.0

var _jumps_made = 0

@onready var _animated_sprite = $AnimatedSprite2D
@onready var _start_scale = _animated_sprite.scale

func _physics_process(delta: float) -> void:
	var _horizontal_direction = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	velocity.x = _horizontal_direction * speed
	velocity.y += gravity * delta
	
	var is_falling = velocity.y > 0.0 and not is_on_floor()
	var is_jumping = Input.is_action_just_pressed("jump") and is_on_floor()
	var is_double_jumping = Input.is_action_just_pressed("jump") and is_falling
	var is_jump_cancelled = Input.is_action_just_released("jump") and velocity.y < 0.0
	var is_idling = is_on_floor() and is_zero_approx(velocity.x)
	var is_running = is_on_floor() and not is_zero_approx(velocity.x)
	
	if is_jumping:
		_jumps_made += 1
		velocity.y = -jump_strenght
	elif is_double_jumping:
		_jumps_made += 1
		if _jumps_made <= maximum_jumps:
			velocity.y = -double_jump_strenght
	elif is_jump_cancelled:
		velocity.y = 0.0
	elif is_idling or is_running:
		_jumps_made = 0;
				
	move_and_slide()
	
	if not is_zero_approx(velocity.x):
		_animated_sprite.scale.x = sign(velocity.x) * _start_scale.x
	
	if is_jumping or is_double_jumping:
		_animated_sprite.play("jump")
	elif is_running:
		_animated_sprite.play("walk")
	elif is_falling:
		_animated_sprite.play("fall")
	elif is_idling:
		_animated_sprite.play("idle")
	
