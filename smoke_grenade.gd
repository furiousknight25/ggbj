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
	apply_torque_impulse(direction * .3)
	get_purple_green_components(factors)
	timer.start()
	$CollisionShape3D/CPUParticles3D.emitting = true

var purple_level = 0.0
var green_level = 0.0

func get_purple_green_components(color: Color):
	# Purple is defined as the presence of Red and Blue
	purple_level = (color.r + color.b) * 0.5
	
	# Green is just the green channel
	green_level = color.g
	

func explode():
	freeze = true
	if purple_level == 0.0 and green_level == 0.0: return
	# Make sure this node name matches your scene tree
	Vision_collision_shape_3d.disabled = false 
	
	# --- PURPLE LOGIC (Red + Blue) ---
	if purple_level > green_level:
		# Assuming Purple triggers the "Vision/Magic" effect
		vision_box.start(GDB.smoke_time)
		$visionSound.play()
		
	# --- GREEN LOGIC ---
	elif green_level >= purple_level:
		# Assuming Green triggers the "Hurt/Acid" effect
		hurt_box.start(GDB.smoke_time)
		$HurtSound.play()

func _on_smoke_finished() -> void:
	await get_tree().create_timer(50.0).timeout
	queue_free()

var bounce = 4
var wait = false
var old_body = null
func _process(delta: float) -> void:
	
	if get_contact_count() > 0 and wait == false and old_body != get_colliding_bodies()[0]:
		old_body = get_colliding_bodies()[0]
		wait = true
		bounce -= 1
		match bounce:
			1:
				$"1".play()
			2:
				$"2".play()
			3:
				$"3".play()
		await get_tree().create_timer(.2).timeout
		wait = false
