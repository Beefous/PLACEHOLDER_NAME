extends Node

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const TERMINAL_VELOCITY = -400

func _gravity(MAX_VELOCITY, delta):
	var velocity: float = 0.0
	velocity += gravity * delta
	velocity = clampf(velocity, TERMINAL_VELOCITY, MAX_VELOCITY)
	return velocity


