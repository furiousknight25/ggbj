extends Node3D
@onready var player = get_tree().get_first_node_in_group("player")
@onready var area_3d: Area3D = $Area3D

@onready var csg_box_3d: CSGBox3D = $CSGBox3D
@onready var start: Marker3D = $Start
@onready var end: Marker3D = $End
@onready var cam: CSGBox3D = $Cam
@onready var ray_cast_3d: RayCast3D = $Cam/RayCast3D

var closed = false
func _process(delta: float) -> void:
	if area_3d.get_overlapping_bodies().has(player):
		cam.look_at(player.global_position)
		if ray_cast_3d.is_colliding():
			if ray_cast_3d.get_collider() == player:
				closed = true
			else:
				closed = false
	else:
		closed = false
	if closed:
		csg_box_3d.global_position = csg_box_3d.global_position.lerp(end.global_position, delta * 40)
	else:
		csg_box_3d.global_position = csg_box_3d.global_position.lerp(start.global_position, delta * 40)
