extends PathFollow2D

func _process(delta: float) -> void:
	progress_ratio += 0.1 * delta
