extends Node

const MUSIC_BUS_INDEX = 1
const SFX_BUS_INDEX = 2
const SETTINGS_PATH = "user://settings.cfg"

var music_volume: float = 0.8:
	set(value):
		music_volume = clamp(value, 0.0, 1.0)
		_update_music_volume()
		_save_settings()

var sfx_volume: float = 0.8:
	set(value):
		sfx_volume = clamp(value, 0.0, 1.0)
		_update_sfx_volume()
		_save_settings()

signal music_volume_changed(volume: float)
signal sfx_volume_changed(volume: float)

func _ready() -> void:
	_load_settings()
	_update_music_volume()
	_update_sfx_volume()

func _update_music_volume() -> void:
	var db = linear_to_db(music_volume)
	AudioServer.set_bus_volume_db(MUSIC_BUS_INDEX, db)
	AudioServer.set_bus_mute(MUSIC_BUS_INDEX, music_volume <= 0.0)
	music_volume_changed.emit(music_volume)

func _update_sfx_volume() -> void:
	var db = linear_to_db(sfx_volume)
	AudioServer.set_bus_volume_db(SFX_BUS_INDEX, db)
	AudioServer.set_bus_mute(SFX_BUS_INDEX, sfx_volume <= 0.0)
	sfx_volume_changed.emit(sfx_volume)

func set_music_volume(volume: float) -> void:
	music_volume = volume

func set_sfx_volume(volume: float) -> void:
	sfx_volume = volume

func get_music_volume() -> float:
	return music_volume

func get_sfx_volume() -> float:
	return sfx_volume

func _save_settings() -> void:
	var config = ConfigFile.new()
	config.set_value("audio", "music_volume", music_volume)
	config.set_value("audio", "sfx_volume", sfx_volume)
	config.save(SETTINGS_PATH)

func _load_settings() -> void:
	var config = ConfigFile.new()
	var err = config.load(SETTINGS_PATH)
	if err == OK:
		music_volume = config.get_value("audio", "music_volume", 0.8)
		sfx_volume = config.get_value("audio", "sfx_volume", 0.8)
