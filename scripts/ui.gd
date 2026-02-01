extends Control

@onready var player: Player = $".."
@onready var cursor: Area2D = $Cursor

@onready var mixer_bod: Node2D = $"Smoke Grenade/mix/Mixer"

@onready var mixer: TextureRect = $"Smoke Grenade/mix/TextureRect"

var frozen = false

var holding 

var mixing_level = 0

func _process(delta: float) -> void:
	if !player.mouse_enabled: return
	
	cursor.global_position = cursor.global_position.lerp(get_global_mouse_position(), delta * 12)
	
	if Input.is_action_pressed("rightclick"):
		for i in cursor.get_overlapping_bodies():
			if i.has_method("interact"):
				i.interact(get_global_mouse_position())
	
	if Input.is_action_just_pressed("rightclick"):
		for i in cursor.get_overlapping_bodies():
			if i.has_method("interact_once"):
				i.interact_once()
		
