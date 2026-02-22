extends Node2D

const button_sequence = preload("res://scenes/ui/qte/buttonSequence.tscn")

@onready var interaction_area = $InteractionArea

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact():
	if not gs.is_chased:
		var instance: ButtonSequence = button_sequence.instantiate()
		instance.finished.connect(_on_button_sequence_finished.bind(instance))
		get_tree().root.get_child(0).add_child(instance)

func _on_button_sequence_finished(success: bool, instance: Node) -> void:
	# TODO: Show
	gs.is_chaotic = success
	instance.queue_free()
