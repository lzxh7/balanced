class_name Sticky
extends Node

# for things that should not move when stuck inside a static body, like sticks

@onready var parent: RigidBody2D = $".."
var just_unfrozen = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent.disable_mode = CollisionObject2D.DISABLE_MODE_MAKE_STATIC
	parent.contact_monitor = true
	parent.max_contacts_reported = 5
	parent.freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if not parent.freeze and just_unfrozen:
		just_unfrozen = false
		if parent.get_colliding_bodies().map(func(x): return x is StaticBody2D).has(true):
			parent.process_mode = PROCESS_MODE_DISABLED
		parent.contact_monitor = false
