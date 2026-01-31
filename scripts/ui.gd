extends Control

@onready var player: CharacterBody3D = $".."
@onready var cursor: Area2D = $Cursor

func _process(delta: float) -> void:
	cursor.global_position = cursor.global_position.lerp(get_global_mouse_position(), delta * 12)
	

func _on_button_pressed() -> void:
	pass # Replace with function body.
