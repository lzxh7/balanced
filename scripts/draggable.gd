class_name Draggable
extends Node

@export var not_draggable_area: Area2D
@export var warning_icon_texture: Texture2D = load("res://textures/warning_icon.png")

const ROTATION_SENSITIVITY := 0.025

var dragging := false
var rotating := false

@onready var parent: CollisionObject2D = $".."
@onready var warning_icon := Sprite2D.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# the input_event signal is emitted by CollisionObject2Ds when they recieve
	# an input event like being clicked
	# we manually connect the signal to our method by code to make so we don't
	# have to do it manually every time we use this node
	parent.input_event.connect(_on_input_event)

	parent.input_pickable = true
	parent.freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC

	warning_icon.texture = warning_icon_texture
	add_child(warning_icon)


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
	if event.is_action_pressed("rotate"):
		if not dragging:
			rotating = true

func _unhandled_input(event: InputEvent) -> void:
	# _on_input_event is only triggered when the mouse is over the rb so we use
	# _input for mouse motion and releasing the mouse
	if event.is_action_released("drag"):
		dragging = false
	if event.is_action_released("rotate"):
		rotating = false

	# freeze should be renamed frozen then this would be more readable
	if event is InputEventMouseMotion and parent.freeze:
		if dragging:
			parent.position += event.relative
		if rotating:
			parent.rotation += event.relative.x * ROTATION_SENSITIVITY


func _physics_process(_delta: float) -> void:
	warning_icon.visible = parent.freeze and not_draggable_area.overlaps_body(parent)
	warning_icon.position = parent.position
