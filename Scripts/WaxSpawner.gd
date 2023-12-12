extends StaticBody2D

@onready var timer = $Timer
@onready var spawn_point = $SpawnPoint

@export var wax_chunk : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.timeout.connect(spawn_wax_chunk)
	timer.start()

func spawn_wax_chunk():
	var chunk = wax_chunk.instantiate()
	chunk.position = spawn_point.position
	add_child(chunk)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
