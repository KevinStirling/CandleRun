extends StaticBody2D

#@export var fall_speed : float
@export var fall_height : float
@export var fall_time_to_descent : float

@onready var fall_gravity : float = ((-2.0 * fall_height) / (fall_time_to_descent * fall_time_to_descent)) * -1.0
@onready var trigger_area = $TriggerArea

# Called when the node enters the scene tree for the first time.
func _ready():
	trigger_area.body_entered.connect(_body_entered)

func _body_entered(body : Node2D):
#	check if body is tile map or character
	if body is TileMap:
		queue_free()
	elif body is CharacterBody2D:
		if body.has_method("increase_anim_size") :
			body.increase_anim_size()
			queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y += fall_gravity * delta
	
