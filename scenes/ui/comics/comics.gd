class_name Comics
extends Control

@onready var texture_rect: TextureRect = %TextureRect
@onready var timer: Timer = %Timer

var panels: Array[Texture2D] = []
var panel_index = 0:
	set(newValue):
		panel_index = newValue
		db.p("Panel " + str(panel_index))

var transition: Callable

func setup(panels: Array[Texture2D], transition: Callable) -> void:
	assert(panels.size() > 0, "Panels array must not be empty")

	self.panels = panels
	self.transition = transition
	panel_index = 0
	texture_rect.texture = panels[panel_index]
	timer.start()

func _input(event: InputEvent) -> void:
	if !visible: return

	if event.is_action_pressed("next_comic"):
		panel_index += 1
		timer.stop()

		if panel_index >= panels.size():
			transition.call()
			return

		texture_rect.texture = panels[panel_index]
		timer.start()

func _on_timer_timeout() -> void:
	panel_index += 1
	if panel_index >= panels.size():
		timer.stop()
		return

	texture_rect.texture = panels[panel_index]
