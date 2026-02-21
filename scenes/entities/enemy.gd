class_name Enemy
extends CharacterBody2D

enum { PATROL, CHASE, RETURN }

@export var speed := 100
@export var aggro_range := 250.0
@export var lose_range := 320.0
@export var path: Path2D
@export var patrol_arrive_dist := 12.0

@onready var agent: NavigationAgent2D = %agent

var state := PATROL
var patrol_points: PackedVector2Array
var patrol_index := 0

@onready var player: CharacterBody2D = null

func _ready():
	patrol_points = _get_patrol_points_world()
	agent.path_desired_distance = 6.0
	agent.target_desired_distance = 8.0
	_set_patrol_target()

func _physics_process(delta):
	_update_state()

	match state:
		PATROL:
			if global_position.distance_to(agent.target_position) <= patrol_arrive_dist:
				patrol_index = (patrol_index + 1) % patrol_points.size()
				_set_patrol_target()
			_follow_agent(speed)

		CHASE:
			assert(player != null)
			agent.target_position = player.global_position
			_follow_agent(speed * 1.15)

		RETURN:
			_follow_agent(speed)
			if global_position.distance_to(agent.target_position) <= patrol_arrive_dist:
				state = PATROL
				agent.target_position = _closest_point_on_patrol(global_position)

func _update_state():
	match state:
		PATROL:
			if player != null:
				state = CHASE

		CHASE:
			if player == null:
				state = RETURN

func _follow_agent(move_speed: float):
	var direction: Vector2 = (agent.get_next_path_position() - global_position).normalized()
	velocity = direction * move_speed
	if direction != Vector2.ZERO:
		rotation = direction.angle()
	move_and_slide()

func _set_patrol_target():
	if patrol_points.is_empty():
		return
	var target := patrol_points[patrol_index]
	agent.target_position = target

func _get_patrol_points_world() -> PackedVector2Array:
	var pts := PackedVector2Array()
	assert(path != null && path.curve != null)
	for i in path.curve.point_count:
		var local_p = path.curve.get_point_position(i)
		pts.append(path.to_global(local_p))
	return pts

func _closest_point_on_patrol(p: Vector2) -> Vector2:
	if patrol_points.size() == 1:
		patrol_index = 0
		return patrol_points[0]

	var best_point := patrol_points[0]
	var best_dsq := INF
	var best_i := 0
	for i in patrol_points.size():
		var a = patrol_points[i]
		var b = patrol_points[(i + 1) % patrol_points.size()]
		var cp = _closest_point_on_segment(p, a, b)
		var dsq = p.distance_squared_to(cp)

		if dsq < best_dsq:
			best_dsq = dsq
			best_point = cp
			best_i = i

	patrol_index = best_i
	return best_point

func _closest_point_on_segment(p: Vector2, a: Vector2, b: Vector2) -> Vector2:
	var ab = b - a
	var t = 0.0
	var denom = ab.length_squared()
	if denom > 0.0:
		t = (p - a).dot(ab) / denom
	t = clamp(t, 0.0, 1.0)
	return a + ab * t
