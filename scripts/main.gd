extends Node

@export var levels: Array[PackedScene]

@onready var ui: UI = $UI

var level_node: Level
var level_id: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_go_button_pressed() -> void:
	level_node.frozen = false


func load_level(id: int) -> void:
	if level_node != null:
		level_node.queue_free()
	level_node = levels[id].instantiate()
	add_child(level_node)
