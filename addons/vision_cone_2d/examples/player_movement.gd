extends CharacterBody2D

class_name player_movement

@export var speed = 1.
@export var distance = 300.
@export var feathers : CPUParticles2D 

@onready var pos_start = position.x

func _physics_process(delta: float) -> void:
	var target_pos = pos_start + sin(Time.get_ticks_msec()/1000. * speed) * distance
	velocity = Vector2(target_pos - position.x, 0)
	move_and_slide()

var seen_count := 0

func toggle_particles():
	if feathers:
		feathers.emitting = seen_count > 0

func seen():
	seen_count += 1
	toggle_particles()

func unseen():
	seen_count -= 1
	toggle_particles()
