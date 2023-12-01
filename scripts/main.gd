class_name Main
extends Node

@export var levels: Array[PackedScene]
@export var ghost_objects_color: Color

@onready var ui: UI = $UI

var ghost_objects: Array[Node]
var level: Level
var level_id: int = -1

signal level_completed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$UI/Screens/Options/GridContainer/MusicSlider.value = Save.data["music_volume"]
	$UI/Screens/Options/GridContainer/SFXSlider.value = Save.data["sfx_volume"]
	$UI/Screens/Options/GridContainer/ImperialMassCheck.button_pressed = Save.data["america_mode"]

	set_up_button_sounds()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_go_button_pressed() -> void:
	if level.can_start:
		level.frozen = false


func _on_level_completed() -> void:
	$LevelComplete.play()
	Save.set_value("level_completion", int(Save.data["level_completion"]) | (1 << level_id))
	level_completed.emit()


func _on_level_button_pressed(id: int) -> void:
	ui.set_screen("InGame")
	load_level(id)


func _on_music_slider_value_changed(value: float) -> void:
	Save.set_value("music_volume", value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), 20 * log((value + 1) / 100))


func _on_sfx_slider_value_changed(value: float) -> void:
	Save.set_value("sfx_volume", value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), 20 * log((value + 1) / 100))

func _on_imperial_mass_check_toggled(button_pressed: bool) -> void:
	Save.set_value("america_mode", button_pressed)


func set_up_button_sounds(from: Node = self):
	for child in from.get_children():
		set_up_button_sounds(child)
		if child is BaseButton:
			child.pressed.connect($Click.play)


func load_level(id: int) -> void:
	level_id = id

	clear_level()
	level = levels[id].instantiate() as Level
	add_child(level)
	level.level_completed.connect(_on_level_completed, CONNECT_ONE_SHOT)
	level.mass_inspected.connect($UI/Screens/InGame/MassLabel._on_mass_inspected)


func reset_level() -> void:
	load_level(level_id)


func create_ghosts() -> void:
	clear_ghosts()
	for node in level.get_ghosts():
		var transform := node.get_global_transform()
		node = node.duplicate()
		ghost_objects.append(node)
		node.modulate = ghost_objects_color
		add_child(node)
		node.transform = transform

func clear_ghosts() -> void:
	for node in ghost_objects:
		node.queue_free()
	ghost_objects.clear()

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
