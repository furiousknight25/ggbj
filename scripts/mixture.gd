extends CharacterBody2D

@onready var polygon_2d: Polygon2D = $Polygon2D

func init(color: Color):
	polygon_2d.color = color
