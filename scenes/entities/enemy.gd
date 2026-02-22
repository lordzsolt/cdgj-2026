class_name Enemy
extends CharacterBody2D

enum { PATROL, CHASE, RETURN, HUNT, PANIC }

enum Type { CHICKEN, ROOSTER }

@export var type: Type
@export var speed := 100
@export var chase_speed_multiplier = 1.5
@export var path: Path2D
@export var patrol_arrive_dist := 12.0
@export var detection_grace_period: float = 0.5
@export var panic_wander_radius: float = 300.0
@export var hit_distance := 3
@export var hit_cooldown := 5000

@onready var agent: NavigationAgent2D = %agent
@onready var feather_particle: CPUParticles2D = %featherParticle
@onready var main_character_sprite: AnimatedSprite2D
@onready var rooster_sprite: AnimatedSprite2D = %roosterSprite
@onready var chicken_sprite: AnimatedSprite2D = %chickenSprite
@onready var vision_cone: VisionCone2D = $visionCone

var state := PATROL
var patrol_points: PackedVector2Array
var patrol_index := 0
var detection_timer: SceneTreeTimer
var _panic_tick: float = 0.0
var _last_hit_time_ms : int = 0

@onready var player: Player = null

func _ready():
	if path != null:
		patrol_points = _get_patrol_points_world()
		agent.path_desired_distance = 6.0
		agent.target_desired_distance = 8.0
		_set_patrol_target()

	if type == Type.CHICKEN:
		main_character_sprite = chicken_sprite
		rooster_sprite.visible = false
		speed = 100
	else:
		main_character_sprite = rooster_sprite
		chicken_sprite.visible = false
		speed = 150
	main_character_sprite.visible = true


func _physics_process(delta):
	_update_state()

	match state:
		PATROL:
			feather_particle.emitting = true
			main_character_sprite.play("walk")
			if global_position.distance_to(agent.target_position) <= patrol_arrive_dist:
				patrol_index = (patrol_index + 1) % patrol_points.size()
				_set_patrol_target()
			_follow_agent(speed)

		CHASE:
			assert(player != null)
			feather_particle.emitting = false
			main_character_sprite.play("run")
			agent.target_position = player.global_position
			_follow_agent(speed * chase_speed_multiplier)
			if global_position.distance_to(player.position) <= hit_distance:
				player.hit()
				_last_hit_time_ms = Time.get_ticks_msec()
				state = RETURN
				player = null
				gs.is_chased = false

		RETURN:
			feather_particle.emitting = true
			_follow_agent(speed)
			if global_position.distance_to(agent.target_position) <= patrol_arrive_dist:
				state = PATROL
				agent.target_position = _closest_point_on_patrol(global_position)

		HUNT:
			feather_particle.emitting = false
			main_character_sprite.play("run")
			agent.target_position = player.global_position
			_follow_agent(speed * chase_speed_multiplier)

		PANIC:
			feather_particle.emitting = false
			main_character_sprite.play("run")
			_panic_tick -= delta
			if _panic_tick <= 0.0:
				_panic_tick = 1.0
				var angle := randf_range(0.0, TAU)
				var dist := randf_range(100, panic_wander_radius)
				agent.target_position = global_position + Vector2(cos(angle), sin(angle)) * dist
			_follow_agent(speed * chase_speed_multiplier)


func _update_state():
	if gs.is_chaotic:
		if type == Type.ROOSTER:
			player = get_tree().get_first_node_in_group("player")
			if player == null:
				db.e("Player was not found, nothing in player group.")
				return
			state = HUNT
			return
		else:
			vision_cone.angle_deg = 360
			vision_cone.max_distance = 100
			vision_cone._angle = deg_to_rad(vision_cone.angle_deg)
			vision_cone._angle_half = vision_cone._angle / 2.0
			vision_cone._angular_delta = vision_cone._angle / vision_cone.ray_count
			vision_cone.recalculate_vision(true)
			state = PANIC

	match state:
		PATROL:
			if player != null:
				state = CHASE
				gs.is_chased = true
		CHASE:
			if player == null:
				state = RETURN
				gs.is_chased = false
		_:
			return

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


func _on_vision_cone_area_body_entered(body: Node2D) -> void:
	if body is Player:
		var current_time_ms := Time.get_ticks_msec()
		if current_time_ms - _last_hit_time_ms < hit_cooldown:
			db.log("Ignoring player")
			return

		detection_timer = get_tree().create_timer(detection_grace_period)
		detection_timer.timeout.connect(_detect_player.bind(body))

func _detect_player(body: Player):
	if detection_timer == null:
		return
	player = body

func _on_vision_cone_area_body_exited(body: Node2D) -> void:
	detection_timer = null
	if body is Player:
		player = null
