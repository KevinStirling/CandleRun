extends CharacterBody2D

# DEBUG SHIT
@onready var size_1 = $"../CanvasLayer/Size1"
@onready var size_2 = $"../CanvasLayer/Size2"
@onready var size_3 = $"../CanvasLayer/Size3"


@onready var animation_size_1 = $Size1
@onready var animation_size_2 = $Size2
@onready var animation_size_3 = $Size3

@onready var collision_shape_size_1 = $CollisionShapeSize1
@onready var collision_shape_size_2 = $CollisionShapeSize2
@onready var collision_shape_size_3 = $CollisionShapeSize3

@onready var current_animation_size : AnimatedSprite2D

const SPEED = 100.0
#const JUMP_VELOCITY = -250.0

@export var jump_height : float
@export var jump_time_to_peak: float
@export var jump_time_to_descent : float

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	current_animation_size = animation_size_1
	size_1.pressed.connect(func():
		animation_size_1.visible = true
		animation_size_2.visible = false
		animation_size_3.visible = false
		collision_shape_size_1.disabled = false
		collision_shape_size_2.disabled = true
		collision_shape_size_3.disabled = true
		current_animation_size = animation_size_1
		)
	size_2.pressed.connect(func():
		animation_size_1.visible = false
		animation_size_2.visible = true
		animation_size_3.visible = false
		collision_shape_size_1.disabled = true
		collision_shape_size_2.disabled = false
		collision_shape_size_3.disabled = true
		current_animation_size = animation_size_2
		)
	size_3.pressed.connect(func():
		animation_size_1.visible = false
		animation_size_2.visible = false
		animation_size_3.visible = true
		collision_shape_size_1.disabled = true
		collision_shape_size_2.disabled = true
		collision_shape_size_3.disabled = false
		current_animation_size = animation_size_3
		)

func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity


func _physics_process(delta):
	# Add the gravity.
	# with this jump gravity impl, if you dont start on the floor you cant jump..
	if not is_on_floor():
		#velocity.y += gravity * delta
		velocity.y += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if velocity.x > 0 :
			current_animation_size.flip_h = false
		else:
			current_animation_size.flip_h = true
		current_animation_size.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		current_animation_size.play("idle")

	move_and_slide()
