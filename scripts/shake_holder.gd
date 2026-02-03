extends Node2D

var base_pos = Vector2(-124, 0)

@onready var progress_bar: ProgressBar = $ProgressBar

func _ready() -> void:
	Director.connect("graffiti_add", add_amount)
	Director.connect("graffiti_start", toggle)

func _process(delta: float) -> void:
	progress_bar.position = lerp(progress_bar.position, base_pos, delta * 12)
var on = false
func toggle():
	on = !on
	var tween = get_tree().create_tween()
	if on:
		tween.tween_property(self, "position:y", 30.0, .5)
	else:
		tween.tween_property(self, "position:y", -70.0, .5)

var off = false
func add_amount(amount):
	if off: return
	progress_bar.value = amount
	position += Vector2.ONE * randf_range(-1,1)
	progress_bar.modulate = Color.RED
	
	if progress_bar.value == progress_bar.max_value and !off:
		off = true
		progress_bar.modulate = Color.GREEN
		done()
		await get_tree().create_timer(1.0).timeout
		progress_bar.value = 0.0
		off = false

func done():
	var tween = get_tree().create_tween()
	progress_bar.scale = Vector2(.5,.5)
	tween.tween_property(progress_bar, "scale", Vector2(1,1), .5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
