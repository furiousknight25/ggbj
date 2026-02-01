extends StaticBody3D

@export var ink: Color
@onready var csg_sphere_3d: CSGSphere3D = $CSGSphere3D
@onready var player = get_tree().get_first_node_in_group("player")

var delta_tot = 0

func _ready() -> void:
	# Ensure the material is unique so you don't change every sphere in the game
	if csg_sphere_3d.material:
		csg_sphere_3d.material = csg_sphere_3d.material.duplicate()
	
	# Apply the color when the node first loads
	update_color()

func init(col : Color):
	ink = col
	print(ink)
	# FIX: Force the material to update right now!
	update_color()

func update_color():
	# We check 'is_inside_tree()' to make sure the @onready variables are loaded
	if is_inside_tree() and csg_sphere_3d.material:
		csg_sphere_3d.material.albedo_color = ink

func _process(delta: float) -> void:
	delta_tot += delta
	csg_sphere_3d.position.y = sin(delta_tot) * .2

func interact():
	player.add_mixture(ink)
	queue_free()
