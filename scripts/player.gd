extends CharacterBody3D

var mouse_sensitivity = 0.002
var jump_strength = 3
var friction = .1

@onready var camera_3d: Camera3D = $Camera3D
@onready var ray_cast_3d: RayCast3D = $Camera3D/RayCast3D
@onready var hand: Marker3D = $Hand

const SMOKE_GRENADE = preload("res://scenes/smoke_grenade.tscn")


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _physics_process(delta: float) -> void:
	
	var input = Input.get_vector('left',"right","forward","back")
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y) #makes sure the forward is the forward you are facing
	
	
	if is_on_floor():
		var current_friction: Vector2 = Vector2(velocity.x, velocity.z).rotated(PI) * friction
		var friction_dir = transform.basis * Vector3(current_friction.x, 0, current_friction.y)
		velocity += Vector3(current_friction.x, 0, current_friction.y)
		velocity += Vector3(movement_dir.x, 0, movement_dir.z)
	
	
	if Input.is_action_just_pressed('jump'):
		velocity.y += jump_strength
		
	velocity.y -= 9.8 * delta#gravity
	
	if Input.is_action_just_pressed("leftclick"):throw()
	if Input.is_action_just_pressed("rightclick"):
		if ray_cast_3d.is_colliding():
			var raycast_col = ray_cast_3d.get_collider()
			print(raycast_col)
			if raycast_col and raycast_col.is_in_group("interact"):
				raycast_col.interact()
	
	move_and_slide()

func interact():
	pass

func throw():
	var smoke  : SmokeGrenade =  SMOKE_GRENADE.instantiate()
	get_tree().get_root().add_child(smoke)
	smoke.global_position = hand.global_position
	smoke.init(-camera_3d.global_transform.basis.z.normalized(), {})
	print(camera_3d.global_transform.basis.z.normalized())

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera_3d.rotate_x(-event.relative.y * mouse_sensitivity)
