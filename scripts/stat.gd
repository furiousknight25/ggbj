extends Node3D
@onready var player :Player = get_tree().get_first_node_in_group("player")
const YELLOWSPRAYPOINT = preload("res://scenes/yellowspraypoint.tscn")
@onready var area_3d: Area3D = $Area3D

@export var door : Door
var paint_meter = 0
var done = false

var can_paint = false
func interacting():
	can_paint = true

var music_started = false
func _on_timer_timeout() -> void:
	if can_paint:
		if can_paint and done == false and music_started == false:
			music_started = true
			Music.request_new('bosa')
		for i in area_3d.get_overlapping_bodies():
			if i.is_in_group('enemy'):
				i.set_chase()
		paint_meter += .1
		if paint_meter > 10 and done == false:
			done = true
			door.open()
			Music.request_new('chill')
		var yp = YELLOWSPRAYPOINT.instantiate()
		add_child(yp)
		
		if yp and player.give_spray():
			yp.global_position = player.give_spray()
	can_paint = false
