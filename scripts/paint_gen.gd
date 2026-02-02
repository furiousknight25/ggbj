class_name PaintGen extends TextureRect

const PAINT_IN_BOTTLE = preload("res://scenes/paintInBottle.tscn")
@onready var paint_holder: VBoxContainer = $PaintHolder

var average_mix : Color
func add_paint(col : Color):
	var new_paint = PAINT_IN_BOTTLE.instantiate()
	new_paint.color = col
	paint_holder.add_child(new_paint)

func get_mix():
	var total_color = Color(0, 0, 0, 0)
	var count = 0
	
	for child in paint_holder.get_children():
		if child is ColorRect:
			total_color += child.color
			count += 1
			child.queue_free()
	
	if count > 0:
		add_paint(total_color / count)
		return total_color / count
	print('no color found')
	return Color.WHITE # Return a default if no ColorRects found


func _on_mix_layer_body_entered(body: Mixture) -> void:
	add_paint(body.get_mix())
	body.queue_free()
