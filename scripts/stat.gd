extends Node3D
@onready var player :Player = get_tree().get_first_node_in_group("player")
const YELLOWSPRAYPOINT = preload("res://scenes/yellowspraypoint.tscn")

@export var door : Door
var paint_meter = 0
var done = false

var can_paint = false
func interacting():
	can_paint = true

func _on_timer_timeout() -> void:
	if can_paint:
		paint_meter += .1
		if paint_meter > 10 and done == false:
			done = true
			door.open()
		
		var yp = YELLOWSPRAYPOINT.instantiate()
		add_child(yp)
		
		if yp and player.give_spray():
			yp.global_position = player.give_spray()
	
	can_paint = false
