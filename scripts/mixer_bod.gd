extends CharacterBody2D

var mix_state = false
var mix_level = 0.0
var mixing = false
@onready var player: Player = $"../../../.."
@onready var texture_rect: TextureRect = $Sprite2D/TextureRect

func interact(pos : Vector2):
	if mix_state: return
	velocity += pos - global_position
	rotation += randf_range(-.1,.1)
	if mix_level > 3.0:
		mix_state = true
		player.current_paint = texture_rect.get_mix()
		await get_tree().create_timer(3.0).timeout
		mix_state = false
		mix_level = 0.0
	mixing = true

func _process(delta: float) -> void:
	if mixing: 
		mix_level += delta
		mixing = false
	
	rotation = lerp(rotation, 0.0, delta * 2)
	
	velocity.y += 9.8
	move_and_slide()
