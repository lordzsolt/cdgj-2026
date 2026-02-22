extends Node2D

const button_sequence = preload("res://scenes/ui/qte/buttonSequence.tscn")

@onready var interaction_area = $InteractionArea

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (gs.is_chased && interaction_area.is_visible_in_tree()):
		interaction_area.get_node("CollisionShape2D").disabled = true    # disable
	elif (!gs.is_chased):
		interaction_area.get_node("CollisionShape2D").disabled = false   # enable

func _ready():
	print(interaction_area)
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact():
	if not gs.is_chased:
		var instance: ButtonSequence = button_sequence.instantiate()
		instance.finished.connect(_on_button_sequence_finished.bind(instance))
		add_child(instance)

func _on_button_sequence_finished(success: bool, instance: Node) -> void:
	if success:
		instance.queue_free()
	else:
		instance.queue_free()
