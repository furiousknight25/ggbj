class_name SlipGrenade extends Area3D
var level = 0.0
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var slip_smoke: CPUParticles3D = $SlipSmoke

func start(lvl : float):
	level = lvl
	slip_smoke.lifetime = level
	slip_smoke.emitting = true
	collision_shape_3d.disabled = false

func _on_timer_timeout() -> void:
	if slip_smoke.emitting:
		for i in get_overlapping_bodies():
			if i.has_method("slip"):
				i.slip()


func _on_slip_smoke_finished() -> void:
	collision_shape_3d.disabled = true
