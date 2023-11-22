extends Label

var should_show := false
var america_mode: bool

const KG_TO_LBS := 2.20462262185

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if should_show == false:
		hide()
	should_show = false


func _on_mass_inspected(mass: float) -> void:
	show()
	should_show = true
	if america_mode:
		text = "%s lbs" % (mass * KG_TO_LBS)
	else:
		text = "%s kg" % mass

func _on_visibility_changed() -> void:
	america_mode = Save.data["america_mode"]
