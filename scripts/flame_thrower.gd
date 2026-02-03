extends Area3D

@onready var cpu_particles_3d: CPUParticles3D = $CPUParticles3D

var disabled = false
func shoot():
	cpu_particles_3d.emitting = true
	for i in get_overlapping_bodies():
		if i.has_method('flame') and disabled == false:
			disabled = true
			i.flame()
			#$fire.play()
