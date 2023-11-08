class_name UI
extends CanvasLayer

enum UIState {
	START_SCREEN,
	IN_GAME,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func set_ui_state(state: UIState) -> void:
	for child in get_children():
		if child.has_method("hide"):
			child.hide()
	get_child(state).show()
