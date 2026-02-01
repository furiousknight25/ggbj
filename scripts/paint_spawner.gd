extends Node3D

@export var col : Color

const SELECT_INK = preload("res://scenes/selectInk.tscn")

@onready var spawn_point: Marker3D = $spawnPoint
@onready var timer: Timer = $Timer

func _process(delta: float) -> void:
	if spawn_point.get_child_count() == 0 and timer.is_stopped():
		timer.start()

func _on_timer_timeout() -> void:
	var ink = SELECT_INK.instantiate()
	spawn_point.add_child(ink)
	ink.init(col)
	
