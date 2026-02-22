class_name PF
extends Node

enum Scene {
	MAIN_MENU,
	LEVEL_1,
}

static func load_scene(scene: Scene) -> Node:
	match scene:
		Scene.MAIN_MENU:
			return load("res://scenes/ui/main_menu/main_menu.tscn").instantiate()
		Scene.LEVEL_1:
			return load("res://scenes/levels/level1_vision/level1_vision.tscn").instantiate()
		_:
			db.e("Scene not found: " + Scene.keys()[scene])
			return null
