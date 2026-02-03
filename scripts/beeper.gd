extends OmniLight3D
@onready var ping: AudioStreamPlayer3D = $ping
@onready var timer: Timer = $Timer

var max = 10
var timer_lvl = 0
var timer_cur = 10
var on = false
func distance_beep(distance):
	if distance.length() < max:
		timer_lvl = distance.length()
		#print(timer_lvl)
		if timer_lvl != 0:
			ping.pitch_scale = 1 - timer_lvl / 10
	on = true
func _on_timer_timeout() -> void:
	if on:
		on = false
		set_visible(!visible)
		$ping.play()
		timer_cur = timer_lvl
		if timer_lvl > 0:
			timer.wait_time = timer_lvl * .1
	
