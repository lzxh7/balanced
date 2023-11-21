class_name UI
extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func set_screen(screen_name: String) -> void:
	for child in $Screens.get_children():
		if child.has_method("hide"):
			child.hide()
	get_node("Screens/" + screen_name).show()
