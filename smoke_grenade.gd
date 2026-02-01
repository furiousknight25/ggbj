class_name SmokeGrenade extends RigidBody3D

@onready var timer: Timer = $Timer
@onready var vision_box: StaticBody3D = $VisionBox
@onready var Vision_collision_shape_3d: CollisionShape3D = $VisionBox/CollisionShape3D
@onready var slip_box: SlipGrenade = $SlipBox
@onready var hurt_box: SmokeGrenadeHurt = $HurtBox

@onready var vision_smoke: CPUParticles3D = $VisionBox/VisionSmoke
@onready var hurt_smoke: CPUParticles3D = $HurtBox/HurtSmoke
@onready var slip_smoke: CPUParticles3D = $SlipBox/SlipSmoke


var vision_level : float = 5.0
var hurt_level : float = 0.0 #max to one they even out to 1
var slip_level : float = 5.0
#divy between 10 

func init(direction: Vector3, factors : Color): #TODO no 2 stage right now 
	freeze = false
	apply_central_impulse(direction * GDB.throwStrength)
	apply_torque_impulse(direction * .1)
	get_red_white_yellow_components(factors)
	timer.start()

func get_red_white_yellow_components(color: Color):
	vision_level = color.b
	hurt_level = color.r - color.g
	slip_level = color.g - color.b
	print(vision_level, " ", hurt_level, " ", slip_level)
	
func explode():
	freeze = true
	Vision_collision_shape_3d.disabled = false
	if vision_level > hurt_level and vision_level > slip_level: 
		vision_box.start(GDB.smoke_time)
	if hurt_level > vision_level and hurt_level > slip_level: 
		hurt_box.start(GDB.smoke_time)
	if slip_level > hurt_level and slip_level > vision_level: 
		slip_box.start(GDB.smoke_time)

func _on_smoke_finished() -> void:
	await get_tree().create_timer(50.0).timeout
	queue_free()
