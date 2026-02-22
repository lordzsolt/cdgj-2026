extends Node2D

func _ready() -> void:
	if Config.debug_auto_win:
		get_tree().create_timer(3.0).timeout.connect(
			func():
				gs.is_chaotic = true
		)

func _on_success_area_body_entered(body: Node2D) -> void:
	if gs.is_chaotic and body is Player:
		Main.instance.win_game()
