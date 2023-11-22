class_name Main
extends Node

@export var levels: Array[PackedScene]

@onready var ui: UI = $UI

var level: Level
var level_id: int = -1

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
		$UI/Screens/InGame/HBoxContainer/ResetButton.show()
		$UI/Screens/InGame/HBoxContainer/GoButton.hide()


func _on_level_completed() -> void:
	Save.set_value("level_completion", int(Save.data["level_completion"]) | (1 << level_id))
	level_completed.emit()


func _on_level_button_pressed(id: int) -> void:
	ui.set_screen("InGame")
	load_level(id)


func load_level(id: int = -1) -> void:
	if id == -1:
		id = level_id
	level_id = id

	if level != null:
		level.queue_free()
	level = levels[id].instantiate() as Level
	add_child(level)
	level.level_completed.connect(_on_level_completed, CONNECT_ONE_SHOT)
	level.mass_inspected.connect($UI/Screens/InGame/MassLabel._on_mass_inspected)

func next_level(from_start: bool = false) -> void:
	var level_completion := int(Save.data["level_completion"])
	if from_start:
		level_id = -1
	for _i in levels.size():
		level_id += 1
		level_id %= levels.size()
		if not (level_completion & (1 << level_id)):
			load_level(level_id)
			return
	assert(false, "add a win screen")
