class_name Player
extends CharacterBody2D


@export var speed: float = 150.0;
@export var run_speed: float = 300.0;
@export var acc: float = 50.0;
@export var max_speed: float = 225.0;

const JUMP_VELOCITY = -400.0;

func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		
	var input_vector = Input.get_vector("left", "right", "up", "down");

	var is_running = Input.is_key_pressed(KEY_SHIFT)
	var target_speed = run_speed if is_running else speed
	var target_velocity = input_vector * target_speed

	velocity = velocity.move_toward(target_velocity, acc)

	move_and_slide()
