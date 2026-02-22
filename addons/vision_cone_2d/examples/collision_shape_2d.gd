@tool
extends CollisionShape2D

func _ready() -> void:
	shape = create_polygon_circle(10, 16)

func create_polygon_circle(radius: float, segments: int) -> ConvexPolygonShape2D:
	var points := PackedVector2Array()
	for i in segments:
		var angle = TAU * i / segments
		points.append(Vector2(cos(angle), sin(angle)) * radius)

	var shape := ConvexPolygonShape2D.new()
	shape.points = points
	return shape
