class_name PF
extends Node

enum Scene {
	MAIN_MENU,
	LEVEL_1,
	LEVEL_2,
	DEFEAT_SCENE,
}

static func load_scene(scene: Scene) -> Node:
	match scene:
		Scene.MAIN_MENU:
			return load("res://scenes/ui/main_menu/main_menu.tscn").instantiate()
		Scene.LEVEL_1:
			return load("res://scenes/levels/level1_vision/level1_vision.tscn").instantiate()
		Scene.LEVEL_2:
			return load("res://scenes/levels/level2_vision/level2_vision.tscn").instantiate()
		Scene.DEFEAT_SCENE:
			return load("res://scenes/ui/death_screen/death_screen.tscn").instantiate()
		_:
			db.e("Scene not found: " + Scene.keys()[scene])
			return null
