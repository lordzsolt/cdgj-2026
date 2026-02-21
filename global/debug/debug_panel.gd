class_name DebugPanel
extends VBoxContainer

@onready var fps_label: Label = %fpsLabel

func _process(_delta: float) -> void:
	fps_label.text = str(Engine.get_frames_per_second())
