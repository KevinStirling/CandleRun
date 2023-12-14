extends Node2D
class_name Lantern

@onready var area_2d = $Area2D
@onready var fire_sprite = $FireSprite

signal fire_lit

# Called when the node enters the scene tree for the first time.
func _ready():
	area_2d.area_entered.connect(ignite)

func ignite(area : Area2D):
	if area.name == "Flame":
		fire_sprite.visible = true
		fire_lit.emit()
