class_name Main
extends Node

@export var levels: Array[PackedScene]

@onready var ui: UI = $UI

var level: Level
var level_id: int

signal level_completed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_go_button_pressed() -> void:
	if level.can_start:
		level.frozen = false


func _on_level_completed() -> void:
	Save.set_value("level_completion", int(Save.data["level_completion"]) | (1 << level_id))
	level_completed.emit()


func _on_level_button_pressed(id: int) -> void:
	ui.set_screen("InGame")
	load_level(id)


func _on_next_button_pressed() -> void:
	load_level(level_id + 1)


func load_level(id: int = -1) -> void:
	if id == -1:
		id = level_id
	level_id = id

	if level != null:
		level.queue_free()
	level = levels[id].instantiate() as Level
	add_child(level)
	level.level_completed.connect(_on_level_completed, CONNECT_ONE_SHOT)

