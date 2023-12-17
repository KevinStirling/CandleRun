extends Node2D

@export var levels : Array[PackedScene]

var current_level : int = 0
var current_level_instance : Level


# Called when the node enters the scene tree for the first time.
func _ready():	
	next_level()

func next_level():
	var level = levels[current_level].instantiate()
	if current_level_instance != null:
		current_level_instance.queue_free()
	current_level_instance = level
	add_child(current_level_instance)
	current_level_instance.won.connect(func():
		print("hit")
		await get_tree().create_timer(1.5).timeout
		current_level += 1
		next_level()
	)
