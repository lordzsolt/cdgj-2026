class_name Game
extends Node3D

@export var coin_speed := 6.0

@onready var coin: MeshInstance3D = %coin

func _process(delta: float) -> void:
	coin.rotate_y(coin_speed * delta)
