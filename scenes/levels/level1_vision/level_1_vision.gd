extends Control

@export var stealth_texture: TextureRect
@export var stealth_enemies: Node2D

@export var chaotic_texture: TextureRect
@export var chaotic_enemies: Node2D

func _ready() -> void:
	stealth_mode = true

var stealth_mode : bool:
	set(value):
		stealth_enemies.visible = value
		stealth_texture.visible = value

		chaotic_enemies.visible = !value
		chaotic_texture.visible = !value

		if value:
			stealth_enemies.process_mode = Node.PROCESS_MODE_INHERIT
			chaotic_enemies.process_mode = Node.PROCESS_MODE_DISABLED
		else:
			stealth_enemies.process_mode = Node.PROCESS_MODE_DISABLED
			chaotic_enemies.process_mode = Node.PROCESS_MODE_INHERIT

		gs.is_chaotic = !value

func start_chaotic():
	stealth_mode = false

func _process(delta: float) -> void:
	stealth_mode = !gs.is_chaotic
