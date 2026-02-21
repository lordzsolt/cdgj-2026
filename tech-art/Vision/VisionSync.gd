extends Node

@export var level_camera : Camera2D
@export var view_camera : Camera2D
@export var map_camera : Camera2D

@export var level_viewport : SubViewport
@export var view_viewport : SubViewport
@export var map_viewport : SubViewport

@export var level_player : Node2D
@export var view_player : Node2D
@export var map_player : Node2D

func _process(delta: float) -> void:
	view_camera.zoom = level_camera.zoom
	map_camera.zoom = level_camera.zoom
	
	level_viewport.size = DisplayServer.window_get_size()
	view_viewport.size = DisplayServer.window_get_size()
	map_viewport.size = DisplayServer.window_get_size()
	
	view_player.transform = level_player.transform
	map_player.transform = level_player.transform
