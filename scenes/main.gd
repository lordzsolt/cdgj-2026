class_name Main
extends Node

static var instance: Main

# To improve:
# - Pause handling to make it more idiot proof
# - active_scene and game_ui node content

@onready var root: Node = %root
var _active_scene: Node

@onready var game_ui: Node = %game_ui
@onready var comics: Comics = %Comics

var _pause_menu: Node
var _settings_menu: Node

var is_paused: bool = false:
	set(value):
		if is_paused == value: return
		db.p("Paused " + str(value))
		is_paused = value
		if value:
			pause_game()
			_active_scene.process_mode = Node.PROCESS_MODE_DISABLED
		else:
			if _pause_menu:
				GAudio.uiPlop()
				_pause_menu.queue_free()
			_active_scene.process_mode = Node.PROCESS_MODE_INHERIT

func _ready() -> void:
	instance = self
	if Config.debug_skip_main_menu:
		play_game()
	else:
		switch_scene(PF.Scene.MAIN_MENU)

func open_settings():
	GAudio.uiPlop()
	var scene = load("res://scenes/ui/settings_menu/settings_menu.tscn")
	_settings_menu = scene.instantiate()
	game_ui.add_child(_settings_menu)

func close_settings():
	if _settings_menu:
		GAudio.uiPlop()
		_settings_menu.queue_free()

func pause_game():
	GAudio.uiPlop()
	var scene = load("res://scenes/ui/pause_menu/pause_menu.tscn")
	_pause_menu = scene.instantiate()
	game_ui.add_child(_pause_menu)

func resume_game():
	is_paused = false
	GAudio.uiPlop()

func play_game():
	comics.setup([
		preload("res://art/IntroComicDEMO.png"),
		preload("res://art/IntroComicDEMO.png"),
		preload("res://art/IntroComicDEMO.png"),
	], func():
		comics.visible = false
		switch_scene(PF.Scene.LEVEL_1)
	)

	comics.visible = true

func show_level_success():
	_active_scene.process_mode = Node.PROCESS_MODE_DISABLED

	comics.setup([
		preload("res://art/IntroComicDEMO.png"),
		preload("res://art/IntroComicDEMO.png"),
		preload("res://art/IntroComicDEMO.png"),
	], func():
		comics.visible = false
		switch_scene(PF.Scene.LEVEL_2)
	)

	comics.visible = true

func switch_scene(scene: PF.Scene):
	is_paused = false

	if _active_scene:
		GAudio.uiPlop()
		_active_scene.queue_free()
	_active_scene = PF.load_scene(scene)
	root.add_child(_active_scene)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_game"):
		# Ignore pause action in the main menu
		if _active_scene is MainMenu: return

		# Ignore un-pause action when Pause Menu -> Settings is open
		if %game_ui.get_child_count() > 1: return

		is_paused = !is_paused
