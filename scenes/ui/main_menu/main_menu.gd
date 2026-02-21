class_name MainMenu
extends Control

@onready var play_button: Button = %playButton
@onready var settings_button: Button = %settingsButton
@onready var close_button: Button = %closeButton

func _ready():
	play_button.button_up.connect(func(): Main.instance.switch_scene(PF.Scene.GAME))

	settings_button.button_up.connect(func(): Main.instance.open_settings())

	if EnvUtils.is_web():
		close_button.hide()
	else:
		close_button.button_up.connect(func(): get_tree().quit())
