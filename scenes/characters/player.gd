class_name Player
extends CharacterBody2D

@export var animation_player_2: AnimationPlayer

@export var speed: float = 200.0;
@export var run_speed: float = 300.0;
@export var acc: float = 50.0;
@export var max_speed: float = 225.0;

@export var stamina: float = 100.0;
@export var rotation_speed: float = PI * 2;

# Stamina constants
const STAMINA_MAX: float = 100.0;
const STAMINA_MIN: float = 0.0;
const STAMINA_EXHAUSTED_THRESHOLD: float = 80.0;
const STAMINA_DRAIN_RATE: float = 45.0;  # per second
const STAMINA_REGEN_RATE: float = 45.0;   # per second
var got_tired: bool = false;
var _theta: float;

# Movement state for stamina calculation
var _is_moving: bool = false;
var _is_running: bool = false;

var health := 1

func hit():
	health -= 1

	if health <= 0:
		Main.instance.show_defeat()

func _ready() -> void:
	health = 1

@onready var animated_sprite = $MainCharacterSprite
const JUMP_VELOCITY = -400.0;

func can_run() -> bool:
	return !is_exhausted()

func is_exhausted() -> bool:
	var is_exhausted: bool = false;
	if (got_tired):
		is_exhausted = stamina <= STAMINA_EXHAUSTED_THRESHOLD
	else:
		is_exhausted = stamina <= STAMINA_MIN;

	if (is_exhausted):
		animation_player_2.play("exhausted")
	else:
		animation_player_2.stop()
	return is_exhausted;

func _drain_stamina(delta: float) -> void:
	stamina = max(STAMINA_MIN, stamina - STAMINA_DRAIN_RATE * delta)
	if (stamina <= 0):
		got_tired = true;
		animated_sprite.play("walk");

func _regen_stamina(delta: float) -> void:
	stamina = min(STAMINA_MAX, stamina + STAMINA_REGEN_RATE * delta)
	if (got_tired && stamina >= STAMINA_EXHAUSTED_THRESHOLD):
		got_tired = false;

func _process(delta: float) -> void:
	if _is_running:
		_drain_stamina(delta)
	else:
		_regen_stamina(delta)

func _physics_process(delta: float) -> void:
	var input_vector = Input.get_vector("left", "right", "up", "down");

	var is_running_pressed = Input.is_key_pressed(KEY_SHIFT);
	var target_speed = speed;
	_is_moving = input_vector.length() > 0
	_is_running = false

	if _is_moving:
		if is_running_pressed:
			if can_run():
				animated_sprite.play("run");
				target_speed = run_speed;
				_is_running = true
			else:
				# Still regenerating even when exhausted and holding shift
				pass
		else:
			animated_sprite.play("walk");

		_theta = wrapf(atan2(input_vector.y, input_vector.x) + PI/2 - rotation, -PI, PI);
		rotation += clamp(rotation_speed * delta, 0, abs(_theta)) * sign(_theta)
	else:
		animated_sprite.stop();

	var target_velocity = input_vector * target_speed;
	velocity = velocity.move_toward(target_velocity, acc)
	move_and_slide()
