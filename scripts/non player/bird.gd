extends CharacterBody2D


const JUMP_VELOCITY = -180.0
const TERMINAL_VELOCITY = 200.0


func _ready():
	velocity.x = 50.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var bird = $bird


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += GlobalFunctions._gravity(JUMP_VELOCITY, delta)
	
	if velocity.y > 180:
		velocity.y = JUMP_VELOCITY
	
	move_and_slide()


func _on_view_body_entered(body):
	if body.is_in_group("tile"):
		bird.flip_h = !bird.flip_h
		velocity.x = -velocity.x
	
