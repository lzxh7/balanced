@tool
class_name Level
extends Node2D

@export var frozen: bool:
	set(value):
		frozen = value
		_set_recursive("freeze", value, self)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	frozen = true
	_set_recursive("draggable_area", $NotDraggableArea, self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _set_recursive(property: StringName, value, node: Node) -> void:
	if property in node:
		node.set(property, value)
	if node.get_child_count() > 0:
		for child in node.get_children():
			_set_recursive(property, value, child)

