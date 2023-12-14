extends CharacterBody2D
class_name CandleMan

signal died

# DEBUG SHIT
#@onready var size_1 = $"../CanvasLayer/Size1"
#@onready var size_2 = $"../CanvasLayer/Size2"
#@onready var size_3 = $"../CanvasLayer/Size3"
#@onready var label = $"../CanvasLayer/Label"

@onready var animation_size_1 = $Size1
@onready var animation_size_2 = $Size2
@onready var animation_size_3 = $Size3
@onready var dead = $Dead

@onready var collision_shape_size_1 = $CollisionShapeSize1
@onready var collision_shape_size_2 = $CollisionShapeSize2
@onready var collision_shape_size_3 = $CollisionShapeSize3

@onready var current_animation : AnimatedSprite2D


const SPEED = 100.0
#const JUMP_VELOCITY = -250.0

@export var jump_height : float
@export var jump_time_to_peak: float
@export var jump_time_to_descent : float

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

@export var distance_between_sizes : float
var current_anim_size : int
var current_distance_left : float :
	set (value) :
		if value <= 0.0 && current_anim_size != 1:
			decrease_anim_size()
		elif value <= 0.0 && current_anim_size == 1 :
			process_mode = Node.PROCESS_MODE_DISABLED
			animation_size_1.visible = false
			dead.visible = true
			died.emit()
		elif !is_on_wall():
			current_distance_left = value
			#label.text = str(current_distance_left)
		
	get :
		return current_distance_left

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func increase_anim_size():
	if current_anim_size < 3 && current_anim_size > 0:
		set_anim_size(current_anim_size + 1)
		
func decrease_anim_size():
	if current_anim_size <= 3 && current_anim_size > 1:
		set_anim_size(current_anim_size - 1)


func set_anim_size(size):
	process_mode = Node.PROCESS_MODE_INHERIT
	dead.visible = false
	match size :
		1 :
			current_distance_left = distance_between_sizes
			animation_size_1.visible = true
			animation_size_2.visible = false
			animation_size_3.visible = false
			animation_size_1.process_mode = Node.PROCESS_MODE_INHERIT
			animation_size_2.process_mode = Node.PROCESS_MODE_DISABLED
			animation_size_3.process_mode = Node.PROCESS_MODE_DISABLED
			collision_shape_size_1.disabled = false
			collision_shape_size_2.disabled = true
			collision_shape_size_3.disabled = true
			collision_shape_size_1.set_deferred("disabled", false)
			collision_shape_size_2.set_deferred("disabled", true)
			collision_shape_size_3.set_deferred("disabled", true)
			current_animation = animation_size_1
			current_anim_size = 1
		2 :
			current_distance_left = distance_between_sizes
			animation_size_1.visible = false
			animation_size_2.visible = true
			animation_size_3.visible = false
			animation_size_1.process_mode = Node.PROCESS_MODE_DISABLED
			animation_size_2.process_mode = Node.PROCESS_MODE_INHERIT
			animation_size_3.process_mode = Node.PROCESS_MODE_DISABLED
			collision_shape_size_1.set_deferred("disabled", true)
			collision_shape_size_2.set_deferred("disabled", false)
			collision_shape_size_3.set_deferred("disabled", true)
			current_animation = animation_size_2
			current_anim_size = 2
		3 :
			current_distance_left = distance_between_sizes
			animation_size_1.visible = false
			animation_size_2.visible = false
			animation_size_3.visible = true
			animation_size_1.process_mode = Node.PROCESS_MODE_DISABLED
			animation_size_2.process_mode = Node.PROCESS_MODE_DISABLED
			animation_size_3.process_mode = Node.PROCESS_MODE_INHERIT
			collision_shape_size_1.set_deferred("disabled", true)
			collision_shape_size_2.set_deferred("disabled", true)
			collision_shape_size_3.set_deferred("disabled", false)
			current_animation = animation_size_3
			current_anim_size = 3
			
func _ready():
#	MOVE ALL THIS SHIT INTO SOME STATE MANAGEMENT? eh maybe later...
	set_anim_size(3)
	#size_1.pressed.connect(func():
		#set_anim_size(1))
	#size_2.pressed.connect(func():
		#set_anim_size(2))
	#size_3.pressed.connect(func():
		#set_anim_size(3))
	pass

func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity


func _physics_process(delta):
	# Add the gravity.
	# with this jump gravity impl, if you dont start on the floor you cant jump..
	if not is_on_floor():
		#velocity.y += gravity * delta
		velocity.y += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if velocity.x > 0 :
			current_animation.flip_h = false
		else:
			current_animation.flip_h = true
		current_animation.play("run")
		current_distance_left = current_distance_left - delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		current_animation.play("idle")

	move_and_slide()
