extends RayCast2D

var pressed := false

signal mass_inspected(mass: float)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inspect"):
		pressed = true
	if event.is_action_released("inspect"):
		pressed = false

func _physics_process(_delta: float) -> void:
	if pressed:
		position = get_viewport().get_mouse_position()
		var collider = get_collider()
		if collider is RigidBody2D:
			mass_inspected.emit(collider.mass)
