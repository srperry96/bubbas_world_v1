extends CharacterBody3D


var SPEED = 3
const JUMP_VELOCITY = 6

var walking_speed = 3.0
var running_speed = 6.0

var running = false
var is_locked = false

#@export means these variables are added to the players inspector panel for easier modification
@export var sens_horiz := 0.2
@export var sens_vert := 0.2
@onready var visuals = $visuals

#hold ctrl + drag thing on to automatically make @onready variable
@onready var camera_mount = $camera_mount
@onready var animation_player = $visuals/mixamo_base/AnimationPlayer


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#on start of scene
func _ready():
	#capture mouse
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sens_horiz))
		camera_mount.rotate_x(deg_to_rad(-event.relative.y * sens_vert))
	
		#rotating the player visuals opposite to the camera, so player stays
		#still when camera rotates
		visuals.rotate_y(deg_to_rad(event.relative.x * sens_horiz))


func _process(delta):
	#un-capture mouse on ESC
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _physics_process(delta):
	if not animation_player.is_playing():
		is_locked = false
	
	
	#if kick has only just been pressed
	if Input.is_action_just_pressed("kick"):
		if animation_player.current_animation != "kick":
			animation_player.play("kick")
			is_locked = true
	
	if Input.is_action_pressed("run"):
		SPEED = running_speed
		running = true
	else:
		SPEED = walking_speed
		running = false
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if not is_locked:
		if direction:
			if running:
				if animation_player.current_animation != "running":
					animation_player.play("running")
			else:
				if animation_player.current_animation != "walking":
					animation_player.play("walking")
			visuals.look_at(position + direction)
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
		
			if animation_player.current_animation != "idle":
				animation_player.play("idle")	
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

	if not is_locked:
		move_and_slide()

