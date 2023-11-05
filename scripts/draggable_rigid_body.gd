class_name DraggableRigidBody
extends RigidBody2D

@export var area: Area2D
const ROTATION_SENSITIVITY := 0.025

var dragging := false
var rotating := false

var _accumulated_displacement := Vector2()
var _accumulated_rotation := 0.0
var _temp_transform: Transform2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# the input_event signal is emitted by CollisionObject2Ds when they recieve
	# an input event like being clicked
	# we manually connect the signal to our method by code to make so we don't
	# have to do it manually every time we use this node
	input_event.connect(_on_input_event)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# this has a bug where if we refreeze the level then you can only drag the object
# once but i'm too lazy to fix this since were going to be restarting the entire
# scene anyways
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("drag"):
		if not rotating:
			dragging = true
			print("dragging")
	if event.is_action_pressed("rotate"):
		if not dragging:
			rotating = true
			print("rotating")


func _unhandled_input(event: InputEvent) -> void:
	# _on_input_event is only triggered when the mouse is over the rb so we use
	# _input for mouse motion and releasing the mouse
	if event.is_action_released("drag"):
		dragging = false
	if event.is_action_released("rotate"):
		rotating = false
	
	# freeze should be renamed frozen then this would be more readable
	if event is InputEventMouseMotion and freeze:
		if dragging:
			_accumulated_displacement += event.relative
		if rotating:
			_accumulated_rotation += event.relative.x * ROTATION_SENSITIVITY


func _physics_process(_delta: float) -> void:
	# cmon this makes no sense "if freeze" no freeze is a verb not an adjective
	# it should be frozen "if frozen" actually makes gramatical sense 
	if freeze:
		if area.overlaps_body(self):
			transform = _temp_transform
		_temp_transform = Transform2D(transform)
		
		position += _accumulated_displacement
		rotation += _accumulated_rotation
		_accumulated_displacement = Vector2()
		_accumulated_rotation = 0.0
