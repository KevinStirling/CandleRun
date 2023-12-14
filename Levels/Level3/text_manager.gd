extends CanvasLayer
	
@onready var flammable = $"../Flammable"
@onready var label = $Label


# Called when the node enters the scene tree for the first time.
func _ready():
	flammable.fire_lit.connect(lit)

func lit():
	label.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
