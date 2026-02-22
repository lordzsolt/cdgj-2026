extends Node

@onready var player = get_tree().get_first_node_in_group("player");
@onready var label = $Label;

const baset_text = "Press [E] to ";

var active_areas = [];
var can_interact = true;

func _ready() -> void:
	label.hide()

func register_area(area: InteractionArea):
	active_areas.append(area);
	label.show()

func unregister_area(area: InteractionArea):
	var index = active_areas.find(area);
	if (index != -1):
		label.hide()
		active_areas.remove_at(index);

func _process(delta: float) -> void:
	if active_areas.size() > 0 && can_interact:
		var aa = active_areas[0];
		label.text = baset_text + aa.action_name;
		label.global_position = aa.global_position;
		label.global_position.y -= 36;
		label.global_position.x -= label.size.x / 2;
		label.show();

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("interact") && can_interact):
		if active_areas.size() > 0:
			can_interact = false;
			label.hide()

			await active_areas[0].interact.call();
			can_interact = true;
