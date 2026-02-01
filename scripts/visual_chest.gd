extends Node3D

@onready var body: Body = $"../body"
var blacked = false
func _process(delta: float) -> void:
	if blacked:
		global_rotation = lerp(global_rotation, body.global_rotation, delta * 12)
	global_position = body.global_position

func face_y(why):
	if !blacked:
		rotation.y = why
