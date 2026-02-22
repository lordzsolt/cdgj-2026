extends Node2D

@export var stealth_enemies: Node2D
@export var chaotic_enemies: Node2D

func _ready() -> void:
	stealth_mode = true
	#get_tree().create_timer(1.0).timeout.connect(start_chaotic)

var stealth_mode : bool:
	set(value):
		stealth_enemies.visible = value
		chaotic_enemies.visible = !value
		
		if value:
			stealth_enemies.process_mode = Node.PROCESS_MODE_INHERIT
			chaotic_enemies.process_mode = Node.PROCESS_MODE_DISABLED
		else:
			stealth_enemies.process_mode = Node.PROCESS_MODE_DISABLED
			chaotic_enemies.process_mode = Node.PROCESS_MODE_INHERIT
		
		gs.is_chaotic = !value

func start_chaotic():
	stealth_mode = false
