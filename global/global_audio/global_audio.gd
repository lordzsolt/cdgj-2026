extends Node

@onready var ui_plop: AudioStreamPlayer = %uiPlop

func uiPlop():
	ui_plop.play()
