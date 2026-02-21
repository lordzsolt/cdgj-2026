extends Node

var message_parent: Control

var _template: PackedScene = load("res://global/debug/debug_message.tscn")

func _ready() -> void:
	message_parent = get_tree().get_first_node_in_group("debug_messages")

func p(msg: String) -> void:
	print(msg)
	_add_message(msg, DebugMessage.Type.INFO)

func log(msg: String) -> void:
	print(msg)
	_add_message(msg, DebugMessage.Type.INFO)

func e(msg: String) -> void:
	print("error: " + msg)
	push_error(msg)
	_add_message(msg, DebugMessage.Type.ERROR)

func w(msg: String) -> void:
	print("warn: " + msg)
	_add_message(msg, DebugMessage.Type.WARNING)
	push_warning(msg)

func _add_message(msg: String, type: DebugMessage.Type) -> void:
	var message: DebugMessage = _template.instantiate()
	message_parent.add_child(message)
	message.init(type, msg)
