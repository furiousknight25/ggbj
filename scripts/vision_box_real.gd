extends StaticBody3D
var level = 0.0
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var vision_smoke: CPUParticles3D = $VisionSmoke

func start(lvl : float):
	level = lvl
	vision_smoke.lifetime = level
	vision_smoke.emitting = true
	collision_shape_3d.disabled = false

func _on_vision_smoke_finished() -> void:
	collision_shape_3d.disabled = true
