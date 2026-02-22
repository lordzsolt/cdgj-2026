extends Node2D

func _ready() -> void:
	get_tree().create_timer(1.0).timeout.connect(
		func():
			pass
			#gs.is_chaotic = true
	)
