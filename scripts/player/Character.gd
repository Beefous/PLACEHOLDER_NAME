extends CharacterBody2D
class_name Character2D


var gravity = GlobalFunctions.gravity
@export_range(0.0, 2.0, .25) var friction := 1.0
@export_range(0.0, 4.0, .25) var acceleration := 2.0

var movement_dir:= 0.0

const SPEED = 48
const JUMP_FORCE = 64
