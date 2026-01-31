class_name Body extends RigidBody3D

@export var stiffness: float = 50.0
@export var damping: float = 1.0
var is_ragdolled: bool = false

func _integrate_forces(state):
	# If we are ragdolling, do nothing and let gravity work
	if is_ragdolled:
		return
	
	# --- STAND UP LOGIC ---
	# Calculate the rotation needed to align "My Up" with "World Up"
	var current_up = global_transform.basis.y
	var target_up = Vector3.UP
	
	# The cross product gives us the axis to rotate around
	var torque_dir = current_up.cross(target_up)
	
	# Apply torque: (Distance to target * Stiffness) - (Current spin * Damping)
	# This creates a "Spring" effect that pulls it upright without wobbling forever
	var torque = torque_dir * stiffness - state.angular_velocity * damping
	
	state.apply_torque(torque)

# Call this from anywhere to toggle modes
func toggle_ragdoll(active: bool):
	is_ragdolled = active
	if active:
		# Optional: Give it a little push so it doesn't freeze standing up
		apply_impulse(Vector3.RIGHT * 2.0, Vector3.UP)
