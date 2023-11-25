extends Area2D

@export var impulse_threshold := 450.0
@export var explosiveness := 5000000.0
@export var explosion_range := 500.0

@onready var parent: RigidBody2D = $".."
@onready var particles: GPUParticles2D = $GPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CollisionShape2D.shape.radius = explosion_range
	# this is probably a bad idea but its the only way to override the
	# parent's _integrate_forces() function and access its physics state
	parent.set_script(preload("res://scripts/explosive_rigid_body.gd"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if parent.freeze:
		return

	if parent.max_impulse > impulse_threshold:
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
	# max impulse accumulates over multiple frames so we reset it after using it
	parent.max_impulse = 0
