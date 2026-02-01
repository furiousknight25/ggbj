class_name Mixture extends RigidBody2D

@onready var polygon_2d: Polygon2D = $Polygon2D

func init(color: Color):
	polygon_2d.color = color

func interact_once():
	
	freeze = true
	await get_tree().create_timer(.1).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", Vector2(164,50), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	freeze = false

func get_mix():
	return polygon_2d.color
