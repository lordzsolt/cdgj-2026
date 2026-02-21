class_name DebugMessage
extends PanelContainer

enum Type {
	INFO,
	ERROR,
	WARNING
}

static var info = preload("res://global/debug/icons/information.png")
static var error = preload("res://global/debug/icons/cross.png")
static var warn = preload("res://global/debug/icons/exclamation.png")

@onready var texture_rect: TextureRect = $HBoxContainer/TextureRect
@onready var label: Label = $HBoxContainer/Label

var _type: Type
var _message: String

func _ready():
	# Duplicate the style so each instance can have its own background color
	var style = get_theme_stylebox("panel").duplicate()
	add_theme_stylebox_override("panel", style)

	if !_message.is_empty():
		init(_type, _message)

func init(type: Type, message: String):
	_type = type
	_message = message

	# For some reason, if I directly call Debug.info() in the _ready of the root node, the add_child
	# in debug.gd will not call _ready.
	# No clue what other cases might produce the same behavior, so better be safe ¯\_(ツ)_/¯
	if not is_node_ready():
		return

	label.text = message
	var style = get_theme_stylebox("panel") as StyleBoxFlat
	match type:
		Type.INFO:
			style.bg_color = Color.DARK_GRAY
			texture_rect.texture = info
		Type.ERROR:
			style.bg_color = Color.RED
			texture_rect.texture = error
		Type.WARNING:
			style.bg_color = Color.DARK_GOLDENROD
			texture_rect.texture = warn

func _on_timer_timeout() -> void:
	queue_free()
