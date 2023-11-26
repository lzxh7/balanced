extends Control

@export var title_scene: PackedScene

var title: Node
signal title_added(title: Node)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_visibility_changed() -> void:
	if is_visible_in_tree():
		title = title_scene.instantiate()
		add_child(title)
		move_child(title, 1)
		title_added.emit(title)
	else:
		title.queue_free()
