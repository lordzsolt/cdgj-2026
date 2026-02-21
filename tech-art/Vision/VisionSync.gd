extends Node

@export var level_camera : Camera2D
@export var view_camera : Camera2D

@export var player_level : Node2D
@export var player_view : Node2D

func _process(delta: float) -> void:
	player_view.transform = player_level.transform
	
