extends Node3D
@onready var player = get_tree().get_first_node_in_group("player")
@onready var area_3d: Area3D = $Area3D

@onready var csg_box_3d: CSGBox3D = $CSGBox3D
@onready var start: Marker3D = $Start
@onready var end: Marker3D = $End
@onready var cam = $Leg/Cam
@onready var ray_cast_3d: RayCast3D = $Leg/Cam/Cam/RayCast3D

var closed = false

var can_play = true
func _process(delta: float) -> void:
	if area_3d.get_overlapping_bodies().has(player):
		cam.look_at(player.global_position)
		$Leg/Cam/Cam/Beeper.distance_beep(cam.global_position - player.global_position)
	
	if ray_cast_3d.is_colliding():
			if ray_cast_3d.get_collider() == player:
				closed = true
				if can_play:
					can_play = false
					$door.play()
			else:
				closed = false
				can_play = true
	else:
		closed = false
	if closed:
		csg_box_3d.global_position = csg_box_3d.global_position.lerp(end.global_position, delta * 40)
	else:
		csg_box_3d.global_position = csg_box_3d.global_position.lerp(start.global_position, delta * 40)
