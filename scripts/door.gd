class_name Door extends Node3D

#@onready var door: AnimatableBody3D = $Door
#@onready var start_point : Vector3 = door.global_position
#@onready var final_point: Marker3D = $FinalPoint
@onready var animation_player: AnimationPlayer = $"Node3D/doorr(2)done/AnimationPlayer"

func open():
	var tween = get_tree().create_tween()
	animation_player.play("Cube_001")
	#tween.tween_property(door, "global_position", final_point.global_position, 1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)

func close():
	return
	#var tween = get_tree().create_tween()
	#tween.tween_property(door, "global_position", start_point, 1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
