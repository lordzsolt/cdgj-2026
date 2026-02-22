class_name MainMenu
extends Control

@export var play_button: Button
@export var settings_button: Button
@export var close_button: Button

func _ready():
	play_button.button_up.connect(func():
		Main.instance.play_game()
	)

	settings_button.button_up.connect(func(): Main.instance.open_settings())

	if EnvUtils.is_web():
		close_button.hide()
	else:
		close_button.button_up.connect(func(): get_tree().quit())
