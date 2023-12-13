extends Node2D

@export var player : PackedScene
@export var goal_torch : Flammable
@onready var spawn_point = $SpawnPoint

# Called when the node enters the scene tree for the first time.
func _ready():
	var p = player.instantiate()
	p.position = spawn_point.position
	add_child(p)
	goal_torch.fire_lit.connect(win)

func win():
	# display victory text or whatever
	# load next level / call signal to load next level
	pass
