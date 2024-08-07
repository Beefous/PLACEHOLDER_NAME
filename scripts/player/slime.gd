extends CharacterBody2D

@onready var sprite := $AnimatedSprite2D
@onready var look_dir := $direction
@onready var cursor = $direction/Cursor
@onready var drip = $"AnimatedSprite2D/drip effect"

var wet: bool
var wet_time: Timer
var submerged: bool
var direction
var bounce := false
var charges := 1
var jump_mult := 1.0
var twist_input := 0.0
var mouse_sensitivity := 0.0025
var n: float

const SPEED := 100.0
const ACCELERATION := 8.0
const JUMP_VELOCITY := -150.0


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	drip.emitting = false


func _process(_delta):
	_toggle_mouse()
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		pass
	else:
		_turn_cursor()
		_jump_multiplier()
		_flip_sprite()
		_animate_sprite()
		charges = clampi(charges, 0, 2)
		bounce = true if Input.is_action_pressed("shift") else false
		if wet_time != null:
			if wet_time.is_stopped():
				wet = false
				wet_time.queue_free()
				drip.emitting = false

func _toggle_mouse():
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Engine.time_scale = 0
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		elif Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Engine.time_scale = 1
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
func _turn_cursor():
	look_dir.rotate(twist_input)
	twist_input = 0.0
	look_dir.rotation = wrapf(look_dir.rotation, -PI, PI)
func _jump_multiplier():
	if Input.is_action_just_pressed("scrup"):
		jump_mult += .25
		cursor.position.x +=2
	if Input.is_action_just_pressed("scrown"):
		jump_mult -= .25
		cursor.position.x -=2
	
	jump_mult = clampf(jump_mult, .75, 2.0)
	cursor.position.x = clampf(cursor.position.x, 6.0, 16.0)
func _flip_sprite():
	if velocity.x < 0:
		sprite.flip_h = false
	if velocity.x > 0:
		sprite.flip_h = true
func _animate_sprite():
	direction = Input.get_axis("left", "right")
	
	if direction and is_on_floor_only():
		sprite.play("move")
	if not direction or not is_on_floor_only() or jump_mult < 2:
		sprite.play("default")
	if jump_mult == 2:
		sprite.play("max")


func _physics_process(delta):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		pass
	else:
		var jump_dir = look_dir.rotation
		
		_air_physics(true if Engine.time_scale < .5 else false, delta, jump_dir)
		
		_floor_physics(jump_dir)
		
		_when_wet(jump_dir)
		
		_bounce_mode(jump_dir, delta)
		
		move_and_slide()

func _air_physics(air_strafe: bool, delta, jump_dir):
	if is_on_floor():
		pass
	else:
		velocity.y += GlobalFunctions._gravity(-JUMP_VELOCITY, delta)
		if air_strafe:
			velocity.x = move_toward(velocity.x, direction * (SPEED * .8), ACCELERATION)
		if charges > 0:
			if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
				Engine.time_scale = .1 if Input.is_action_pressed("jump") else 1 
			if Input.is_action_just_released("jump"):
				jump_dir = Vector2.RIGHT.from_angle(jump_dir)
				velocity = (-jump_dir * (JUMP_VELOCITY * jump_mult))
				charges -= 1
func _floor_physics(jump_dir):
	direction = Input.get_axis("left", "right")
	
	if not is_on_floor():
		pass
	else:
		if Engine.time_scale != 1 and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Engine.time_scale = 1
		#recharging
		if charges <= 0:
			charges += 1
			prints(charges)
		#jumping
		if Input.is_action_just_pressed("jump"):
			jump_dir = Vector2.RIGHT.from_angle(jump_dir)
			velocity = velocity - (jump_dir * (JUMP_VELOCITY * jump_mult))
			n = 0
		#moving
		if direction:
			velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION)
		#stopping
		else:
			velocity.x = move_toward(velocity.x, 0, ACCELERATION * 8)
func _when_wet(jump_dir):
	if wet:
		_wall_physics(jump_dir)
		drip.emitting = true
func _wall_physics(jump_dir):
	if not is_on_wall_only():
		pass
	else:
		_wall_hang(jump_dir)
func _wall_hang(jump_dir):
	if not Input.is_action_pressed("jump"):
		velocity = Vector2.ZERO
	if Input.is_action_just_pressed("jump"):
		jump_dir = Vector2.RIGHT.from_angle(jump_dir)
		velocity = (-jump_dir * (JUMP_VELOCITY * jump_mult)) * .8
func _bounce_mode(jump_dir, delta):
	if bounce:
		if is_on_floor():
			jump_dir = Vector2.RIGHT.from_angle(jump_dir)
			velocity = (-jump_dir * (JUMP_VELOCITY * jump_mult))


func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = event.relative.x * mouse_sensitivity


func _on_detector_hitbox_area_exited(area):
	if area.is_in_group("water"):
		wet_time = Timer.new()
		
		wet_time.wait_time = 5
		wet_time.one_shot = true
		wet_time.autostart = true
		
		get_tree().root.add_child(wet_time)
		wet = true
	if area.is_in_group("charge"):
		charges += 1
