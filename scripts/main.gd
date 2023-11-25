class_name Main
extends Node

@export var levels: Array[PackedScene]

@onready var ui: UI = $UI

var level: Level
var level_id: int = -1

signal level_completed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$UI/Screens/Options/GridContainer/MusicSlider.value = Save.data["music_volume"]
	$UI/Screens/Options/GridContainer/SFXSlider.value = Save.data["sfx_volume"]
	$UI/Screens/Options/GridContainer/ImperialMassCheck.button_pressed = Save.data["america_mode"]

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


## -1: reload current level
func load_level(id: int = -1) -> void:
	if id == -1:
		id = level_id
	level_id = id

	clear_level()
	level = levels[id].instantiate() as Level
	add_child(level)
	level.level_completed.connect(_on_level_completed, CONNECT_ONE_SHOT)
	level.mass_inspected.connect($UI/Screens/InGame/MassLabel._on_mass_inspected)


func clear_level() -> void:
	if level != null:
		level.queue_free()


func next_level(from_start: bool = false) -> void:
	var level_completion := int(Save.data["level_completion"])

	if from_start:
		level_id = -1

	if Save.data["seen_win_screen"]:
		load_level((level_id + 1) % levels.size())
		return

	for _i in levels.size():
		level_id += 1
		level_id %= levels.size()
		if not (level_completion & (1 << level_id)):
			load_level(level_id)
			return

	ui.set_screen("Win")
	clear_level()
	Save.set_value("seen_win_screen", true)


func _on_music_slider_value_changed(value: float) -> void:
	Save.set_value("music_volume", value)
	#TODO: set the volume of the music audio bus


func _on_sfx_slider_value_changed(value: float) -> void:
	Save.set_value("sfx_volume", value)
	#TODO: set the volume of the sound effects audio bus


func _on_imperial_mass_check_toggled(button_pressed: bool) -> void:
	Save.set_value("america_mode", button_pressed)
