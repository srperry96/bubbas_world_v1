extends CharacterBody3D

var score := 0
var SPEED = 3
const JUMP_VELOCITY = 15

var walking_speed = 8.0
var running_speed = 15.0

var running = false
#var is_locked = false
var mid_jump = false
var end_level = false

#@export means these variables are added to the inspector panel for easier modification
@export var sens_horiz := 0.2
@export var sens_vert := 0.2
@onready var visuals = $Armature

#hold ctrl + drag thing on to automatically make @onready variable
@onready var camera_mount = $camera_mount
@onready var animation_player = $AnimationPlayer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#animation names
const anim_walk := "anim_hamster_walk"
const anim_jump := "anim_hamster_jump"
const anim_idle := "anim_hamster_idle"


#on start of scene
func _ready():
	#capture mouse
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if not end_level:
		if event is InputEventMouseMotion:
			rotate_y(deg_to_rad(-event.relative.x * sens_horiz))
			camera_mount.rotate_x(deg_to_rad(-event.relative.y * sens_vert))

			camera_mount.rotation.x = clamp(
					camera_mount.rotation.x, 
					deg_to_rad(-30),
					deg_to_rad(30)
			)
			
	#TODO: Add collision mesh  to camera - if collision is detected with anything, dont allow camera to move
	#		-- this should fix issues where camera clips through walls

func _process(delta):
	#un-capture mouse on ESC
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _physics_process(delta):
	#if the end of the level has been reached, stop movement, free mouse so menu can be clicked
	if end_level:
		if animation_player.current_animation != anim_idle:
				animation_player.play(anim_idle)	
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	else:
		#if jump animation has finished playing, or we're on the floor, unlock so other animations can be played
		if not animation_player.is_playing():
			mid_jump = false
			animation_player.play("RESET")
			
#		#if kick has only just been pressed
#		if Input.is_action_just_pressed("kick"):
#			if animation_player.current_animation != "kick":
#				animation_player.play("kick")
#				is_locked = true
		
		if Input.is_action_pressed("run"):
			SPEED = running_speed
			running = true
		else:
			SPEED = walking_speed
			running = false
		
		# Add the gravity.
		if not is_on_floor():
			velocity.y -= gravity * delta * 3.5

		# Handle Jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

			#restart animation if already playing
			if animation_player.is_playing() and animation_player.current_animation == anim_jump:
				animation_player.seek(0.0)
				
			animation_player.play(anim_jump, 0.3, 1.1)
			mid_jump = true
			#TODO: Jump sound signal to trigger jump sound in audio_main_fx

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

		var input_vel = Input.get_axis("move_back", "move_forward")


		if direction:
			if animation_player.current_animation != anim_walk:
				if not mid_jump:
					animation_player.play(anim_walk)
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			if animation_player.current_animation != anim_idle:
				if not mid_jump:
					animation_player.play(anim_idle)
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

		move_and_slide()


func _on_sgnl_end_level():
	end_level = true
	
	#release mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
