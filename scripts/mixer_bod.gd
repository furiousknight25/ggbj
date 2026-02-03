class_name MixerBod extends CharacterBody2D

var mix_state = false
var mix_level = 0.0
var mixing = false
@onready var player: Player = $"../../../.."
@onready var texture_rect: TextureRect = $"../TextureRect"
@onready var mixing_sfx: AudioStreamPlayer = $MixingSFX
@onready var progressmix: ProgressBar = $"../progressmix"

func interact(pos : Vector2):
	if mix_state: 
		progressmix.value = 0.0
		return
	velocity += pos - global_position
	rotation += randf_range(-.1,.1)
	if !mixing_sfx.playing:
		mixing_sfx.play()
	
	if mix_level > 3.0:
		mix_state = true
		player.current_paint = texture_rect.get_mix()
		var tween = get_tree().create_tween()
		progressmix.scale = Vector2(.2,1.5)
		tween.tween_property(progressmix, 'scale', Vector2(1,1), 1.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		await get_tree().create_timer(3.0).timeout
		mix_state = false
		mix_level = 0.0
		
	mixing = true

func _process(delta: float) -> void:
	if !mix_state:
		progressmix.value = mix_level
	if mixing: 
		
		mix_level += delta
		mixing = false
	
	#if mix_level != mix_level - delta:
		#mixing_sfx.stop()
	
	rotation = lerp(rotation, 0.0, delta * 2)
	
	velocity.y += 9.8
	move_and_slide()
