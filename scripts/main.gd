extends Node

@export var levels: Array[PackedScene]

@onready var ui: UI = $UI

var level: Level
var level_id: int


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
	print("Level Completed!")

func load_level(id: int) -> void:
	if level != null:
		level.queue_free()
	level = levels[id].instantiate() as Level
	add_child(level)
	level.level_completed.connect(_on_level_completed, CONNECT_ONE_SHOT)
