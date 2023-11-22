extends GridContainer

var total_levels: int
@export var button_scene: PackedScene
@export var completion_icon: Texture2D
@export var main: Main

var buttons: Array[Button]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	total_levels = main.levels.size()
	add_children()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func add_children() -> void:
	for i in total_levels:
		var button: Button = button_scene.instantiate()
		add_child(button)
		buttons.append(button)

		button.text = str(i + 1)
		# connect the button's pressed signal to main's level selected function
		# with the additional arguement of the level id (i)
		button.pressed.connect(main._on_level_button_pressed.bind(i))
	update_completion_icons()


func update_completion_icons() -> void:
	var level_completion: int = Save.data["level_completion"]
	for i in buttons.size():
		buttons[i].icon = completion_icon if level_completion & (1 << i) else null


func _on_visibility_changed() -> void:
	update_completion_icons()
