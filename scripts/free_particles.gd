extends GPUParticles2D


var emitted := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if emitting:
		if emitted == false:
			$AudioStreamPlayer.play()
			emitted = true
	if emitted and $AudioStreamPlayer.playing == false:
		queue_free()
