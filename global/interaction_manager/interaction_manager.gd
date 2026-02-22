extends Node

@onready var player = get_tree().get_first_node_in_group("player");

const baset_text = "Press [E] to ";

var active_areas = [];
var can_interact = true;

func register_area(area: InteractionArea):
	active_areas.append(area);

func unregister_area(area: InteractionArea):
	var index = active_areas.find(area);
	if (index != -1):
		active_areas.remove_at(index);

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("interact") && can_interact):
		if active_areas.size() > 0:
			can_interact = false;

			await active_areas[0].interact.call();
			can_interact = true;
