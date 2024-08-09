extends Area2D

class_name Charge

var collider = CollisionShape2D.new()
var shape = CircleShape2D.new()
var particles = CPUParticles2D.new()

var added = false

func _ready():
	shape.radius = 2
	collider.shape = shape
	add_child(collider)
	_particle_init()
	body_entered.connect(_on_body_entered)
	add_to_group("charge")

func _on_body_entered(body):
	if body.is_in_group("player")and not added:
		body.charges += 1
		added = true
	if added:
		queue_free()

func _particle_init():
	particles.amount = 10
	particles.lifetime = 10
	particles.preprocess = 10
	particles.texture = load("res://assets/sprites/string segement.png")
	particles.gravity = Vector2.ZERO
	particles.angular_velocity_min = 5
	particles.angular_velocity_max = 15
	particles.angle_min = 0
	particles.angle_max = 360
	particles.color = Color(0, 179, 159)
	particles.hue_variation_min = -1
	particles.hue_variation_curve = Curve.new()
	
	
	add_child(particles)
	
	
