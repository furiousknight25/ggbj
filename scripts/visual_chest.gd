extends Node3D

@onready var body: Body = $"../body"

func _process(delta: float) -> void:
	global_rotation.x = lerp(global_rotation.x, body.global_rotation.x, delta * 12)
	global_rotation.z = lerp(global_rotation.z, body.global_rotation.z, delta * 12)
	global_position = body.global_position

func face_y(why):
	global_rotation.y = why
