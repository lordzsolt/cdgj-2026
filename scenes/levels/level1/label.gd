extends Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (gs.is_chased || gs.is_chaotic):
		hide()
	else:
		show()
