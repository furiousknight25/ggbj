extends WorldEnvironment
@onready var dead: CPUParticles2D = $Dead

func dead_part():
	dead.emitting = true
