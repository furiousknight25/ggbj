extends StaticBody3D
@onready var mark: Marker3D = $Marker3D

@export var door : Door
@onready var omni_light_3d: OmniLight3D = $Marker3D/OmniLight3D

var open_var = false

func open_door():
	var tween = get_tree().create_tween()
	tween.tween_property(mark, "global_rotation", Vector3(0,0,deg_to_rad(-50)), 2.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	door.open()
	omni_light_3d.light_color = Color.GREEN


func close_door():
	var tween = get_tree().create_tween()
	tween.tween_property(mark, "global_rotation", Vector3(0,0, deg_to_rad(50)), 2.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	door.close()
	omni_light_3d.light_color = Color.RED

func interact():
	open_var = !open_var
	$switch.play()
	if !open_var:
		close_door()
	else:
		open_door()

func showUI():
	$"UI Popup".fadeIn()
