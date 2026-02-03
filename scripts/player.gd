class_name Player extends CharacterBody3D

var mouse_sensitivity = 0.002
var jump_strength = 4
var friction = .1

@onready var camera_3d: Camera3D = $Camera3D
@onready var ray_cast_3d: RayCast3D = $Camera3D/RayCast3D
@onready var hand: Marker3D = $Hand
@onready var ui: Control = $UI

const SMOKE_GRENADE = preload("res://scenes/smoke_grenade.tscn")

var mouse_enabled = false
var current_paint : Color
var health = 1
var dead = false

@onready var spray: Node3D = $Camera3D/spray
@onready var hold: Marker3D = $Camera3D/Hold
@onready var gone: Marker3D = $Camera3D/Gone
@onready var shoot: Marker3D = $Camera3D/Shoot
@onready var spray_lerp = gone


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if Director.checkPoint != Vector3.ZERO:
		global_position = Director.checkPoint
	Director.connect("checkpoint", check_anim)
func check_anim():
	$Node2D/CheckPoint/AnimationPlayer.play("checkpoint")
	
func _physics_process(delta: float) -> void:
	if dead: return
	
	if Input.is_action_just_pressed("menu"):
		mouse_enabled = !mouse_enabled
		var tween = get_tree().create_tween()
		if mouse_enabled:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
			tween.tween_property(ui, 'global_position', Vector2(0,0), 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			tween.tween_property(ui, 'global_position', Vector2(0,-1000), 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
	if mouse_enabled:
		pass
		return
	
	var input = Input.get_vector('left',"right","forward","back")
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y) #makes sure the forward is the forward you are facing
	
	if is_on_floor():
		var current_friction: Vector2 = Vector2(velocity.x, velocity.z).rotated(PI) * friction
		var friction_dir = transform.basis * Vector3(current_friction.x, 0, current_friction.y)
		velocity += Vector3(current_friction.x, 0, current_friction.y)
		velocity += Vector3(movement_dir.x, 0, movement_dir.z) * GDB.speed
	else:
		velocity += Vector3(movement_dir.x, 0, movement_dir.z) * GDB.speed * .1
	
	if Input.is_action_just_pressed('jump') and is_on_floor():
		velocity.y += jump_strength
		
	velocity.y -= 9.8 * delta#gravity
	
	if ( ray_cast_3d.is_colliding() and ray_cast_3d.get_collider() != null 
		and (ray_cast_3d.get_collider().is_in_group('uipop'))):
			ray_cast_3d.get_collider().showUI()
	else:
		Director.emit_signal("hideUI")
	
	if ray_cast_3d.is_colliding():
		var raycast_col = ray_cast_3d.get_collider()
		if raycast_col != null:
			if raycast_col.is_in_group("SprayWall"):
				spray_lerp = hold
			else:
				spray_lerp = gone
	else:
		spray_lerp = gone
	
	if Input.is_action_just_pressed("leftclick"):throw()
	if Input.is_action_just_pressed("rightclick"):
		if ray_cast_3d.is_colliding():
			var raycast_col = ray_cast_3d.get_collider()
			if raycast_col and raycast_col.is_in_group("interact"):
				raycast_col.interact()
	if Input.is_action_pressed("rightclick"):
		if ray_cast_3d.is_colliding():
			var raycast_col = ray_cast_3d.get_collider()
			if raycast_col and raycast_col.has_method("interacting"):
				raycast_col.interacting()
				spray_lerp = shoot
				spray.rotation.y += randf_range(-.05,.05)
	spray.global_position = lerp(spray.global_position, spray_lerp.global_position, delta * 25)
	spray.global_rotation = lerp(spray.global_rotation, spray_lerp.global_rotation, delta * 25)
	move_and_slide()

func interact():
	pass

func throw():
	var smoke  : SmokeGrenade =  SMOKE_GRENADE.instantiate()
	get_tree().get_root().add_child(smoke)
	smoke.global_position = hand.global_position
	smoke.init(-camera_3d.global_transform.basis.z.normalized(), current_paint)
	clearInk()
	

func _input(event: InputEvent) -> void:
	if mouse_enabled:
		pass
		return
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera_3d.rotate_x(-event.relative.y * mouse_sensitivity)

@onready var texture_rect: TextureRect = $"UI/Smoke Grenade/mix/TextureRect"
@onready var paint_holder: VBoxContainer = $"UI/Smoke Grenade/mix/TextureRect/PaintHolder"

func add_color(col : Color):
	texture_rect.add_paint(col)
	
func clearInk():
	for i in paint_holder.get_children():
		i.queue_free()
	current_paint = Color(0,0,0)
		
const MIXTURE = preload("res://scenes/mixture.tscn")
@onready var mixtures: StaticBody2D = $"UI/Smoke Grenade/mixtures"

func add_mixture(col : Color):
	if mixtures.get_child_count() > 10:
		return
	var new_mix = MIXTURE.instantiate()
	mixtures.add_child(new_mix)
	new_mix.init(col)
	
func give_spray():
	if ray_cast_3d.is_colliding():
		return ray_cast_3d.get_collision_point() 
func give_normal():
	if ray_cast_3d.is_colliding():
		return ray_cast_3d.get_collision_normal()

func flame():
	health -= 1
	if health <= 0:
		dead = true
		Director.dead_part()
		$Death.play()
		await get_tree().create_timer(3.0).timeout
		get_tree().reload_current_scene()
		
