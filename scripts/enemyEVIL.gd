extends Node3D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var feet: RigidBody3D = $feet
@onready var body: Body = $body
@onready var navigation_agent_3d: NavigationAgent3D = $feet/NavigationAgent3D
@onready var joint: Generic6DOFJoint3D = $body/Generic6DOFJoint3D
@onready var visual_chest: Node3D = $VisualChest
@onready var vision: ShapeCast3D = $VisualChest/Vision
@onready var flame_thrower: Area3D = $VisualChest/Vision/FlameThrower


var health = 5

func _ready() -> void:
	health = GDB.enemy_health

enum STATES {CHASE, DEAD, IDLE, BLACKED}
var cur_state = STATES.IDLE

var idle_pos = Vector3.ZERO
var time_till_bored = 3.0
var can_shoot = true
func _process(delta: float) -> void:
	match cur_state:
		STATES.IDLE:
			feet.angular_damp = 80.0
			vision.force_shapecast_update()
			if vision.is_colliding():
				for index in vision.get_collision_count():
					var collider = vision.get_collider(index)
					if collider.is_in_group("player"):
						set_state_chase()
						break
		STATES.DEAD:
			pass
		STATES.BLACKED:
			pass
		STATES.CHASE:
			feet.angular_damp = 10.0
			if can_shoot:
				for i in flame_thrower.get_overlapping_bodies():
					if i.has_method('flame') and can_shoot:
						can_shoot = false
						flame_thrower.shoot()
						await get_tree().create_timer(GDB.cooldown).timeout
						can_shoot = true
						
			navigation_agent_3d.target_position = player.global_position
			var direction = (navigation_agent_3d.get_next_path_position() - feet.global_position).normalized()
			feet.apply_torque(direction.cross(Vector3.UP) * -GDB.enemy_speed * .2)
			#feet.apply_force(direction * 50)
			
			var target_pos = player.global_position
			# FLATTEN IT: Force the target height to match the chest's height
			target_pos.y = visual_chest.global_position.y 
			# Now look at that flattened point
			visual_chest.look_at(target_pos, Vector3.UP)
			
			vision.force_shapecast_update()
			for index in vision.get_collision_count():
				var collider = vision.get_collider(index)
				if collider.is_in_group("player"):
					time_till_bored = 3.0
					break
			time_till_bored -= delta

func set_state_chase():
	if cur_state != STATES.CHASE and cur_state != STATES.DEAD:
		cur_state = STATES.CHASE
		

func set_state_blacked():
	if cur_state != STATES.BLACKED:
		cur_state = STATES.BLACKED
		body.toggle_ragdoll(true)
		
		await get_tree().create_timer(GDB.blackout_time).timeout 
		if health >= 0:
			body.toggle_ragdoll(false)
			set_state_idle()

func set_state_idle():
	if cur_state == STATES.DEAD: return
	cur_state = STATES.IDLE

func set_state_dead():
	return
	cur_state = STATES.DEAD
	body.toggle_ragdoll(true)
	await get_tree().create_timer(6.0).timeout
	body.freeze = true
	feet.freeze = true

func slip():
	if cur_state == STATES.DEAD: return
	if cur_state != STATES.BLACKED:
		set_state_blacked()

func hit():
	if cur_state == STATES.DEAD: return
	health -= 1
	if health <= 0:
		set_state_dead()
		return
	

@export var stiffness: float = 50.0
@export var damping: float = 10.0
var is_ragdolled: bool = false

func shoot():
	pass

func _idle_timer_timeout() -> void:
	if cur_state == STATES.IDLE:
		pass
