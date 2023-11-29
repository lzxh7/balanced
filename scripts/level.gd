@tool
class_name Level
extends Node2D

@export var frozen: bool:
	set(value):
		frozen = value
		_set_recursive("freeze", value, self)
@export var level_completed_path: NodePath
@export var mass_inspected_path: NodePath
@export var not_draggable_area: Area2D

var can_start: bool:
	get:
		for body in not_draggable_area.get_overlapping_bodies():
			if body.has_node("Draggable"):
				return false
		return true

var level_completed: Signal:
	get:
		var node = get_node_or_null(level_completed_path)
		assert(node != null and node.has_signal("level_completed"))
		return get_node(level_completed_path).level_completed

var mass_inspected: Signal:
	get:
		var node = get_node_or_null(mass_inspected_path)
		assert(node != null and node.has_signal("mass_inspected"))
		return get_node(mass_inspected_path).mass_inspected

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	frozen = true
	_set_recursive("not_draggable_area", not_draggable_area, self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _set_recursive(property: StringName, value, node: Node) -> void:
	if property in node:
		node.set(property, value)
	if node.get_child_count() > 0:
		for child in node.get_children():
			_set_recursive(property, value, child)


# gets the sprite2D's of all draggable nodes. to be used in main.gd to create
# ghost objects
func get_ghosts(from: Node = self) -> Array[Sprite2D]:
	var result: Array[Sprite2D]
	for child in from.get_children():
		result.append_array(get_ghosts(child))
		if child is Draggable:
			for sibling in child.parent.get_children():
				if sibling is Sprite2D:
					result.append(sibling)
	return result
