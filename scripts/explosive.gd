class_name Explosive
extends Area2D

@export var acceleration_threshold := 40000.0
@export var explosiveness := 5000000.0
@export var explosion_range := 500.0

var _old_velocity := Vector2()

@onready var parent: RigidBody2D = $".."
@onready var particles: GPUParticles2D = $GPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CollisionShape2D.shape.radius = explosion_range


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if parent.freeze:
		return
	var acceleration := parent.linear_velocity.distance_to(_old_velocity) / delta

	if (acceleration > acceleration_threshold):
		for body in get_overlapping_bodies():
			if body is RigidBody2D and not body == parent:
				var global_center_of_mass: Vector2 = body.global_position + body.center_of_mass
				body.apply_central_impulse(
						explosiveness /
						global_position.distance_squared_to(global_center_of_mass) *
						global_position.direction_to(global_center_of_mass)
				)
		particles.reparent($"../..")
		particles.emitting = true
		parent.queue_free()
	_old_velocity = parent.linear_velocity
