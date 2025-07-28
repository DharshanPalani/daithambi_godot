extends CharacterBody3D

@export var SPEED: float = 5.0
@export var SPRINT_VALUE: float = 10.0;
@export var MOUSE_SENSITIVITY: float = 0.002
@export var GRAVITY: float = 9.8
@export var JUMP_VELOCITY: float = 4.5

var camera: Camera3D
var rotation_helper: Node3D  # Used for up/down (pitch) rotation

func _ready():
	# Get camera and helper nodes
	camera = $RotationHelper/Camera3D
	rotation_helper = $RotationHelper

	# Lock and hide the mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	# Escape to release mouse
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	# Mouse movement
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)  # Yaw
		rotation_helper.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)  # Pitch
		rotation_helper.rotation_degrees.x = clamp(rotation_helper.rotation_degrees.x, -90, 90)

func _physics_process(delta):
	var input_dir = Vector2.ZERO

	if Input.is_action_pressed("ui_up"):
		input_dir.y -= 1
	if Input.is_action_pressed("ui_down"):
		input_dir.y += 1
	if Input.is_action_pressed("ui_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("ui_right"):
		input_dir.x += 1
	if Input.is_action_just_pressed("sprint"):
		SPEED += SPRINT_VALUE
	if Input.is_action_just_released("sprint"):
		SPEED -= SPRINT_VALUE

	input_dir = input_dir.normalized()

	# Direction relative to where we're facing
	var direction = (global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED

	# Apply gravity
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	else:
		velocity.y = 0
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY

	move_and_slide()
