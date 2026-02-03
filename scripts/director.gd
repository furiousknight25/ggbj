extends Node

#NOTE this is a global that I have in all of my projects, it saves development time by quite a lot
var fullscreen := false 
var textures = []
const DEAD_PART = preload("res://scenes/dead_part.tscn")

signal hideUI
signal checkpoint 

var checkPoint = Vector3.ZERO

func _ready() -> void:
	print(checkPoint)
func _process(_delta):
	
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("fullscreen"):
		if !fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			fullscreen = true
		else:
			fullscreen = false
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	if Input.is_action_just_pressed('restart'):
		get_tree().reload_current_scene()


func set_check_point(Vec : Vector3):
	if Vec != checkPoint:
		checkPoint = Vec
		emit_signal("checkpoint")
		
		return true
	else: return false

func dead_part():
	var dead = DEAD_PART.instantiate()
	add_child(dead)
	dead.emitting = true
	
signal graffiti_add(amount)
signal graffiti_start()
