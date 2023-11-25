extends RigidBody2D

var max_impulse: float = 0

func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 10

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	for i in state.get_contact_count():
		max_impulse = max(max_impulse, state.get_contact_impulse(i).length())
