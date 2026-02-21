extends Node

class_name FeatherSpawner

@export var feather_particles : CPUParticles2D
@export var time_between_spawns := 0.2

var last_spawn_time : float = 0

var disable_next := false

var spawn_rate : float:
	set(value):
		time_between_spawns = 1.0 / value
	get:
		return 1.0 / time_between_spawns

func _ready() -> void:
	feather_particles.one_shot = false
	feather_particles.emitting = false

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.physical_keycode == KEY_P and event.pressed:
			feather_particles.emitting = !feather_particles.emitting

func _process(delta: float) -> void:
	return
	var current_time := 0.001 * Time.get_ticks_msec()
	
	if disable_next:
		feather_particles.emitting = false
		disable_next = false
	
	if current_time > last_spawn_time + time_between_spawns:
		last_spawn_time = current_time
		feather_particles.emitting = true
		disable_next = true
