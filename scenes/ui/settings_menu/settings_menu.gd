class_name SettingsMenu
extends Control

@onready var close_button: Button = %closeButton
@onready var full_screen_checkbox: CheckBox = %fullScreenCheckbox
@onready var music_slider: HSlider = %musicSlider
@onready var sfx_slider: HSlider = %sfxSlider

func _ready() -> void:
	full_screen_checkbox.button_pressed = GameSettings.fullscreen
	music_slider.value = GameSettings.music_volume
	sfx_slider.value = GameSettings.sfx_volume

	close_button.button_down.connect(func(): Main.instance.close_settings())


func _on_full_screen_checkbox_toggled(toggled_on: bool) -> void:
	GameSettings.fullscreen = toggled_on


func _on_music_slider_value_changed(value: float) -> void:
	GameSettings.music_volume = value


func _on_sfx_slider_value_changed(value: float) -> void:
	GameSettings.sfx_volume = value
