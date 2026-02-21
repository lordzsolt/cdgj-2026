class_name PauseMenu
extends Control

@onready var resume_button: Button = %resumeButton
@onready var settings_button: Button = %settingsButton
@onready var quit_button: Button = %quitButton

func _ready() -> void:
	resume_button.button_up.connect(func(): Main.instance.resume_game())
	settings_button.button_up.connect(func(): Main.instance.open_settings())
	quit_button.button_up.connect(func(): Main.instance.switch_scene(PF.Scene.MAIN_MENU))
