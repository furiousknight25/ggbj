extends Control

@onready var player: Player = $".."
@onready var cursor: Area2D = $Cursor


func _process(delta: float) -> void:
	if !player.mouse_enabled: return
	
	cursor.global_position = cursor.global_position.lerp(get_global_mouse_position(), delta * 12)
	

func _on_button_pressed() -> void:
	pass # Replace with function body.
