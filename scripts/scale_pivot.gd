extends RigidBody2D

@export var target_angle := 0.0
@export var target_range: float
@export var target_time: float

var timer: float

signal level_completed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if abs(global_rotation - $"../..".rotation - target_angle) > target_range:
		timer = 0
	else:
		timer += delta
		if timer > target_time:
			level_completed.emit()
