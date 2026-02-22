extends Node

@onready var player = get_tree().get_first_node_in_group("player");

const baset_text = "Press [E] to ";

var active_area = null;
var can_interact = true;

func register_area(area: InteractionArea):
	active_area = area;

func unregister_area(area: InteractionArea):
	active_area = null

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("interact") && can_interact):
		if active_area:
			can_interact = false;

			await active_area.interact.call();
			can_interact = true;
