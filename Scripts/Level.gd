extends Node2D
class_name Level

@export var player : PackedScene
@export var goal_torch : Lantern
@onready var spawn_point = $SpawnPoint

var player_instance : CandleMan

# Called when the node enters the scene tree for the first time.
func _ready():
	player_instance = player.instantiate()
	player_instance.position = spawn_point.position
	add_child(player_instance)
	player_instance.died.connect(lost)
	goal_torch.fire_lit.connect(win)

func win():
	# display victory text or whatever
	# load next level / call signal to load next level
	pass

func lost():
	await get_tree().create_timer(1.5).timeout
	player_instance.set_anim_size(3)
	player_instance.position = spawn_point.position
