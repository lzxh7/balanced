@tool
extends Node2D

@export var reset_pan_rotations: bool:
	set(_value):
		$Pan1.rotation = -rotation
		$Pan2.rotation = -rotation
