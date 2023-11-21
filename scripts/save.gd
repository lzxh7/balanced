class_name Save
extends RefCounted

const SAVE_PATH := "user://save.json"
const DEFAULT_SAVE := {
	"level_completion": 0,
	"sfx_volume": 1.0,
	"music_volume": 1.0,
}

static var data: Dictionary:
	get:
		return JSON.parse_string(FileAccess.get_file_as_string(SAVE_PATH))
	set(value):
		data = value
		var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
		file.store_string(JSON.stringify(value))

static func set_value(key: String, value) -> void:
	var data_copy = data.duplicate()
	data_copy[key] = value
	data = data_copy

static func _static_init() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		data = DEFAULT_SAVE
