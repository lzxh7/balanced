extends GPUParticles2D

# eww memory leaks

var emitted := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if emitting:
		emitted = true
	if emitted and not emitting:
		queue_free()
