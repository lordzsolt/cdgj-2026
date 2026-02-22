class_name PF
extends Node

enum Scene {
	MAIN_MENU,
	GAME,
}

static func load_scene(scene: Scene) -> Node:
	match scene:
		Scene.MAIN_MENU:
			return load("res://scenes/ui/main_menu/main_menu.tscn").instantiate()
		Scene.GAME:
			return load("res://tech-art/Vision/VisionTest.tscn").instantiate()
		_:
			db.e("Scene not found: " + Scene.keys()[scene])
			return null
