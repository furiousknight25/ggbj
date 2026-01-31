class_name SmokeGrenadeHurt extends Area3D
var level = 0.0
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var hurt_smoke: CPUParticles3D = $HurtSmoke

func start(lvl : float):
	level = lvl
	hurt_smoke.lifetime = level
	hurt_smoke.emitting = true
	collision_shape_3d.disabled = false

func _on_timer_timeout() -> void:
	if hurt_smoke.emitting:
		for i in get_overlapping_bodies():
			if i.has_method("hit"):
				i.hit()

func _on_hurt_smoke_finished() -> void:
	collision_shape_3d.disabled = true
