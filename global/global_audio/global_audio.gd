extends Node

@onready var ui_plop: AudioStreamPlayer = %uiPlop
@onready var stealth: AudioStreamPlayer = %Stealth
@onready var chaos: AudioStreamPlayer = %Chaos

func uiPlop():
	ui_plop.play()

func stealth_music():
	if chaos.playing:
		chaos.stop()
	if !stealth.playing:
		stealth.play()

func chaos_music():
	chaos.play()
	stealth.stop()
