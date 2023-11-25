class_name Spawner
extends Node2D

@export var delay := 1.0
@export var scenes: Array[PackedScene]

@export var freeze: bool
@export var time := 0.0

func _process(delta: float) -> void:
	if not freeze:
		time += delta
		if time > delay:
			add_child(scenes.pick_random().instantiate())
			time -= delay
