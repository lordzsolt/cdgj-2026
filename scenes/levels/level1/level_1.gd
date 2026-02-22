extends Node2D

func _on_success_area_body_entered(body: Node2D) -> void:
	if gs.is_chaotic and body is Player:
		Main.instance.show_level_success()
