extends Node

const SETTINGS_PATH := "user://settings.cfg"

var fullscreen: bool = false:
	set(value):
		fullscreen = value
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if value else DisplayServer.WINDOW_MODE_WINDOWED)
		_save_settings()

var music_volume: float = 1.0:
	set(value):
		music_volume = value
		var music_bus = AudioServer.get_bus_index("Music")
		AudioServer.set_bus_volume_db(music_bus, _get_volume_db(value))
		_save_settings()

var sfx_volume: float = 1.0:
	set(value):
		sfx_volume = value
		var music_bus = AudioServer.get_bus_index("SFX")
		AudioServer.set_bus_volume_db(music_bus, _get_volume_db(value))
		_save_settings()

var _is_loaded: bool = false

func _ready():
	_load_settings()
	_is_loaded = true

func _load_settings():
	var cfg = ConfigFile.new()
	cfg.load(SETTINGS_PATH)
	for prop in self.get_property_list():
		if prop.usage & PROPERTY_USAGE_SCRIPT_VARIABLE and not prop.name.begins_with("_"):
			if cfg.has_section_key("settings", prop.name):
				self.set(prop.name, cfg.get_value("settings", prop.name))

func _save_settings():
	if not _is_loaded:
		return

	var cfg = ConfigFile.new()
	for prop in self.get_property_list():
		if prop.usage & PROPERTY_USAGE_SCRIPT_VARIABLE and not prop.name.begins_with("_"):
			cfg.set_value("settings", prop.name, self.get(prop.name))

	cfg.save(SETTINGS_PATH)

func _get_volume_db(volume: float) -> float:
	if volume <= 0.1:
		return -80.0
	else:
		return linear_to_db(volume * 0.5)

func _set_sfx_volume(value: float):
	sfx_volume = value
	# AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(value))
