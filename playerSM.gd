class_name playerSM

extends StateMachine


#     /   /             \   \
#    /   /   /  \  \ \   \   \
#   /   /   / /\ \  \ \   \   \
# <   <    | |  \ \  | |    >   >
#   \   \   \ \  \ \/ /   /   /
#    \   \   \ \  \  /   /   /
#     \   \             /   /


var coyote_timer = Timer.new()
var coyote_frames = 6  # How many in-air frames to allow jumping
var coyote = false  # Track whether we're in coyote time or not
var last_floor = false  # Last frame's on-floor state

var jump_buffer = Timer.new()
var buffer_frames = 6

func _init(_owner: Character2d):
	my_owner = _owner

func on_ready():
	
	coyote_timer.one_shot = true
	coyote_timer.wait_time = coyote_frames / 60.0
	add_child(coyote_timer)
	
	jump_buffer.one_shot = true
	jump_buffer.wait_time = buffer_frames / 60.0
	add_child(jump_buffer)
	
	add_state("walk", walkState.new())
	add_state("jump", jumpState.new())
	add_state("fall", fallState.new())
	add_state("idle", idleState.new())
	initial_state("idle")

func process(_delta):
	flip_sprite()

func physics_process(_delta):
	
	if Input.is_action_just_released("jump") and current_state == fallState:
		jump_buffer.start()
	
	if !my_owner.is_on_floor() and last_floor and current_state != jumpState:
		coyote = true
		coyote_timer.start()
	
	if coyote_timer.is_stopped():
		coyote = false
	
	last_floor = my_owner.is_on_floor()

#func state_changes():
	#if my_owner.velocity.y < 0:
		#change_state("jump")
	#if my_owner.velocity.y > 0:
		#change_state("fall")
	#if abs(my_owner.velocity.x) > 0:
		#change_state("walk")
	#else: change_state("idle")


func flip_sprite():
	if Input.is_action_pressed("left"):
		my_owner.sprite.flip_h = false
	if Input.is_action_pressed("right"):
		my_owner.sprite.flip_h = true






class walkState extends State.Player:
	
	func enter():
		machine_owner.sprite.play('move')
	
	func update(delta):
		super.update(delta)
		if walk_dir.x == 0:
			return "idle"
		if walk_dir.y < 0 and (machine_owner.is_on_floor() or machine.coyote):
			return "jump"
		if machine_owner.velocity.y > 0 and not (machine_owner.is_on_floor() or machine.coyote):
			machine_owner.charges -= 1
			return "fall"
		if walk_dir.y > 0:
			machine_owner.interact()
		else: return
	
	func tick_physics_update(_tick):
		
		machine_owner.movement_dir = walk_dir
		


class idleState extends State.Player:
	
	func enter():
		machine_owner.charges = 1
		machine_owner.sprite.play("idle")
	
	func update(delta):
		super.update(delta)
		if (walk_dir.y < 0 and (machine_owner.is_on_floor() or machine.coyote)) or not machine.jump_buffer.is_stopped():
			return "jump"
		if machine_owner.velocity.y > 0 and not (machine_owner.is_on_floor() or machine.coyote):
			machine_owner.charges -= 1
			return "fall"
		if abs(walk_dir.x) > 0:
			return "walk"
		if walk_dir.y > 0:
			machine_owner.interact()
		else: return
	


class jumpState extends State.Player:
	
	func enter():
		machine_owner.jump()
	
	func update(delta):
		super.update(delta)
		if Input.is_action_just_pressed("jump") and machine_owner.charges > 0:
			return "jump"
		if machine_owner.velocity.y > 0:
			return "fall"
		if machine_owner.is_on_floor():
			return 'idle'
		else: return


class fallState extends State.Player:
	
	func enter():
		machine_owner.sprite.play("fall")
	
	func update(delta):
		super.update(delta)
		if Input.is_action_just_pressed("jump") and machine_owner.charges > 0:
			return "jump"
		if machine_owner.is_on_floor():
			return "idle"
		else: return



