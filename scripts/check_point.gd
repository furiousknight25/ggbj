extends Area3D

@onready var marker_3d: Marker3D = $Marker3D

func _on_body_entered(body: Node3D) -> void:
	Director.set_check_point(marker_3d.global_position)
