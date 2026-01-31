extends Node3D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var feet: RigidBody3D = $feet
@onready var body: RigidBody3D = $body
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

enum STATES {CHASE, DEAD, IDLE}
var cur_state = STATES.IDLE
func _process(delta: float) -> void:
	match cur_state:
		STATES.IDLE:
			pass
		STATES.DEAD:
			pass
		STATES.CHASE:
			navigation_agent_3d.target_position = player.global_position
			
			feet.apply_torque(direction.cross(Vector3.UP) * -GDB.enemy_speed)
