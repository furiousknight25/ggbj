extends Node3D

var start = false

func _process(delta: float) -> void:
	if start == true:
		global_position.z += -1 * delta
		$AnimatableBody3D.global_position.z += -1 * delta

func _on_area_3d_body_entered(body: Node3D) -> void:
	start = true
