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

var original_resolution : Vector2
var original_zoom : Vector2

func _ready() -> void:
	original_resolution = DisplayServer.window_get_size()
	original_zoom = level_camera.zoom

func _process(delta: float) -> void:
	var current_size := DisplayServer.window_get_size()

	level_viewport.size = current_size
	view_viewport.size = current_size
	map_viewport.size = current_size

	var scale_factor := current_size.y / original_resolution.y
	var final_zoom = original_zoom * scale_factor
	level_camera.zoom = final_zoom
	view_camera.zoom = final_zoom
	map_camera.zoom = final_zoom

	view_player.transform = level_player.transform
	map_player.transform = level_player.transform
