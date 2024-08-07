extends Character2d

@onready var direction = $direction
@onready var cursor = $direction/Cursor

var jump_mult := 2.0
var twist_input: float
var state_machine: playerSM

var height : float
var record : float

var charges := 0

var max_stamina = 100
var stamina

var stamina_wait_time = 1

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	state_machine = playerSM.new(self)
	add_child(state_machine)
	
	stamina = max_stamina

func _process(delta):
	charges = clampi(charges, 0, 1)
	
	state_machine.SM_process(delta)
	_pause()
	_turn_cursor()
	#_jump_multiplier(delta)
	_height_query()
	_stamina_color_change()

func _height_query():
	height = -position.y / 8
	record = height if height > record else record

func _pause():
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Engine.time_scale = 0
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			Engine.time_scale = 1

func _turn_cursor():
	direction.rotate(twist_input)
	twist_input = 0.0
	direction.rotation = clampf(direction.rotation, -PI * .8333, -PI * .1667)

func _jump_multiplier(delta):
	if Input.is_action_pressed("jump mult"):
		jump_mult += delta
	elif jump_mult > 1.0: jump_mult -= delta/2
	
	cursor.position.x = ((jump_mult-1)*10) + 6
	
	jump_mult = clampf(jump_mult, 1.0, 2.0)
	cursor.position.x = clampf(cursor.position.x, 6.0, 16.0)

func _stamina_color_change():
	modulate = (Color.WHITE * (stamina / max_stamina))
	modulate.a = 255

func _physics_process(delta):
	state_machine.SM_physics_process(delta)
	ability(delta)
	move(movement_dir, delta)

var t
var gravity_multiplier := 1.0

func ability(delta):
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if Input.is_action_pressed("ability"):
			t = stamina_wait_time
			if stamina > 0:
				Engine.time_scale = .2
				gravity_multiplier = .2
				stamina -= delta * 40 * (1 / Engine.time_scale)
			else: Engine.time_scale = 1; gravity_multiplier = 1
		elif t != null:
			Engine.time_scale = 1
			gravity_multiplier = 1
			t -= delta if t > 0 else 0
			if t <= 0 and stamina != max_stamina:
				stamina = move_toward(stamina, max_stamina, delta * 20)
			

func move(move_dir, delta):
	if move_dir and stamina > 0:
		velocity.x = move_toward(velocity.x, move_dir * SPEED, acceleration)
	elif not is_on_floor():
		velocity.x = move_toward(velocity.x, 0, friction)
	else: velocity.x = move_toward(velocity.x, 0, friction * 8)
	if not is_on_floor():
		velocity.y += gravity * delta * gravity_multiplier
	move_and_slide()

func jump():
	if stamina > 0:
		var jump_dir = direction.rotation
		jump_dir = Vector2.RIGHT.from_angle(jump_dir)
		velocity.y = (jump_dir * (JUMP_FORCE * jump_mult)).y
		velocity.x += (jump_dir * (JUMP_FORCE * jump_mult)).x
		sprite.play("jump")
		charges -= 1

func interact():
	pass

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = event.relative.x * 0.0025
