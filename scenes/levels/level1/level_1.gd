extends Node2D

@onready var stealth_enemies: Node2D = %StealthEnemies

func _ready() -> void:
	get_tree().create_timer(1.0).timeout.connect(_toggle_chaotic)

func _toggle_chaotic():
	stealth_enemies.visible = false
	stealth_enemies.process_mode = Node.PROCESS_MODE_DISABLED

	gs.is_chaotic = true
