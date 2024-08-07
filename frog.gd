extends Character2d

var jump_interval: float
var jump_mult: float
@onready var animation_player = $AnimationPlayer

func _ready():
	randomize_interval()

func random_movement(delta):
	jump_interval -= delta
	if jump_interval <= 0:
		var dir = (randf() * 2) - 1
		if is_on_floor():
			jump(dir)
		
		randomize_interval()

func randomize_interval():
	jump_interval = randf() * randi_range(5, 15)
	jump_mult = (randf() + 1) * 2

func _physics_process(delta):
	random_movement(delta)
	move(delta)

func jump(jump_dir):
	jump_dir = Vector2.RIGHT.from_angle(jump_dir)
	velocity.y = -JUMP_FORCE * jump_mult
	animation_player.play("jump")

func move(delta, move_dir = movement_dir):
	if move_dir:
		velocity.x = move_toward(velocity.x, move_dir * SPEED, acceleration)
	elif not is_on_floor():
		velocity.x = move_toward(velocity.x, 0, friction)
	else: velocity.x = move_toward(velocity.x, 0, friction * 8)
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()
