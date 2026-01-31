extends Node3D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var feet: RigidBody3D = $feet
@onready var body: Body = $body
@onready var navigation_agent_3d: NavigationAgent3D = $feet/NavigationAgent3D
@onready var joint: Generic6DOFJoint3D = $body/Generic6DOFJoint3D
@onready var visual_chest: Node3D = $VisualChest


var health = 10

func _ready() -> void:
	health = GDB.enemy_health

enum STATES {CHASE, DEAD, IDLE, BLACKED}
var cur_state = STATES.IDLE

var idle_pos = Vector3.ZERO

func _process(delta: float) -> void:
	match cur_state:
		STATES.IDLE:
			pass
		STATES.DEAD:
			pass
		STATES.BLACKED:
			pass
		STATES.CHASE:
			navigation_agent_3d.target_position = player.global_position
			var direction = (navigation_agent_3d.get_next_path_position() - feet.global_position).normalized()
			feet.apply_torque(direction.cross(Vector3.UP) * -GDB.enemy_speed)
			#feet.apply_force(direction * 50)
			
			visual_chest.face_y(atan2(direction.x, direction.z))

func set_state_blacked():
	cur_state = STATES.BLACKED
	body.toggle_ragdoll(true)
	
	await get_tree().create_timer(GDB.blackout_time).timeout 
	if health >= 0:
		body.toggle_ragdoll(false)
		set_state_idle()

func set_state_idle():
	cur_state = STATES.IDLE
	
func set_state_dead():
	cur_state = STATES.DEAD
	body.toggle_ragdoll(true)

func hit():
	if cur_state == STATES.DEAD: return
	if health <= 0:
		set_state_dead()
		return
	health -= 1

@export var stiffness: float = 50.0
@export var damping: float = 10.0
var is_ragdolled: bool = false


func _idle_timer_timeout() -> void:
	if cur_state == STATES.IDLE:
		pass
