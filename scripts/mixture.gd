class_name Mixture extends RigidBody2D

@onready var polygon_2d: Polygon2D = $Polygon2D

const TEX_RED = preload("res://assets/pics/red.png")
const TEX_YELLOW = preload("res://assets/pics/yellow.png")
const TEX_BLUE = preload("res://assets/pics/blue.png")

@onready var sprite_2d: Sprite2D = $Sprite2D

func init(color: Color):
	polygon_2d.color = color
	apply_closest_texture(color)
	
func apply_closest_texture(input_color: Color):
	# 1. Snap the messy input color to a "Rigid" constant
	var rigid_color = get_closest_rigid_color(input_color)
	
	# 2. Match the rigid color to the correct texture
	match rigid_color:
		Color.RED:
			sprite_2d.texture = TEX_RED
		Color.YELLOW:
			sprite_2d.texture = TEX_YELLOW
		Color.BLUE:
			sprite_2d.texture = TEX_BLUE
		_:
			push_warning("Color did not match Red, Yellow, or Blue")

# --- The Helper Function (Same as before) ---
func get_closest_rigid_color(c: Color) -> Color:
	var options = [Color.RED, Color.YELLOW, Color.BLUE]
	var best_match = options[0]
	var shortest_dist = 999.0
	
	for option in options:
		var dist = Vector3(c.r, c.g, c.b).distance_squared_to(Vector3(option.r, option.g, option.b))
		if dist < shortest_dist:
			shortest_dist = dist
			best_match = option
			
	return best_match
func interact_once():
	
	freeze = true
	await get_tree().create_timer(.1).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", Vector2(164,50), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	freeze = false

func get_mix():
	return polygon_2d.color
