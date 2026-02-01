extends Node3D
@onready var player = get_tree().get_first_node_in_group("player")
@onready var area_3d: Area3D = $Area3D

@onready var cam: CSGBox3D = $Cam
@onready var ray_cast_3d: RayCast3D = $Cam/RayCast3D
@onready var flame_thrower: Area3D = $Cam/FlameThrower

func _process(delta: float) -> void:
	if area_3d.get_overlapping_bodies().has(player):
		cam.look_at(player.global_position)
		if ray_cast_3d.is_colliding():
			if ray_cast_3d.get_collider() == player:
				flame_thrower.shoot()
