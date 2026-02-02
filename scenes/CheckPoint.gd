extends Node2D

@onready var hit_box = $HitBox
@onready var marker_2d = $Marker2D
@onready var player = get_tree().get_nodes_in_group('player')[0]

func _on_hit_box_body_entered(body):
	if body == player and Director.check_point_position != marker_2d.global_position and player.cur_state != player.STATES.DEAD:
		Director.check_point_position = marker_2d.global_position
		$AudioStreamPlayer.play()
