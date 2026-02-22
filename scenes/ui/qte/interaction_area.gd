class_name InteractionArea
extends Area2D

@export var action_name: String = "interact"

var interact: Callable = func():
	pass;

func _on_body_entered(body: Node2D) -> void:
	if (body is Player && !gs.is_chased && !gs.is_chaotic):
		InteractionManager.register_area(self);

func _on_body_exited(body: Node2D) -> void:
	if (body is Player && !gs.is_chased && !gs.is_chaotic):
		InteractionManager.unregister_area(self);
