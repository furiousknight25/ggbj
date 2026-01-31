class_name SmokeGrenade extends RigidBody3D

@onready var timer: Timer = $Timer
@onready var vision_box: StaticBody3D = $VisionBox
@onready var Vision_collision_shape_3d: CollisionShape3D = $VisionBox/CollisionShape3D

var hurt_level : float = 0.0 #max to one they even out to 1
var vision_level : float = 5.0

#divy between 10 

func init(direction: Vector3, factors : Dictionary): #TODO no 2 stage right now 
	freeze = false
	apply_central_impulse(direction * GDB.throwStrength)
	apply_torque(direction)
	
	timer.start()

func explode():
	freeze = true
	Vision_collision_shape_3d.disabled = false
	
	if vision_level: vision_box.start(vision_level)
	

func _on_smoke_finished() -> void:
	await get_tree().create_timer(50.0).timeout
	queue_free()
