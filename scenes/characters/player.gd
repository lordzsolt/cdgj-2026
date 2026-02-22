class_name Player
extends CharacterBody2D


@export var speed: float = 200.0;
@export var run_speed: float = 300.0;
@export var acc: float = 50.0;
@export var max_speed: float = 225.0;

@export var rotation_speed: float = PI * 2;

var _theta: float;

@onready var animated_sprite = $MainCharacterSprite
const JUMP_VELOCITY = -400.0;



func _physics_process(delta: float) -> void:
	var input_vector = Input.get_vector("left", "right", "up", "down");

	var is_running = Input.is_key_pressed(KEY_SHIFT);
	var target_speed = run_speed if is_running else speed;
	var target_velocity = input_vector * target_speed;

	if input_vector:
		if is_running:
			animated_sprite.play("run");
		else:
			animated_sprite.play("walk");
		_theta = wrapf(atan2(input_vector.y, input_vector.x) + PI/2 - rotation, -PI, PI);
		rotation += clamp(rotation_speed * delta, 0, abs(_theta)) * sign(_theta)
	else:
		animated_sprite.stop();

	velocity = velocity.move_toward(target_velocity, acc)
	move_and_slide()
