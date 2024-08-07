class_name State extends Resource

var machine_owner = null
var machine = null

func enter(): pass

func exit(): pass

func update(_delta): pass

func physics_update(_delta): pass

class Player extends State:
	
	var walk_dir: Vector2 ## x is left/right; y is jump/interact
	
	func update(delta):
		var time := 0.0
		var current_tick := 0
		
		walk_dir.x = Input.get_axis("left","right")
		walk_dir.y = -1.0 if Input.is_action_just_pressed("jump") else Input.get_action_strength("interact")
		machine_owner.movement_dir = walk_dir.x
		time += delta*8
		if time > 8:
			time -= 8
		if int(time) != current_tick:
			current_tick = int(time)
			tick_update(current_tick)
	
	func tick_update(_tick):
		pass
	
	func physics_update(_delta):
		var time := 0.0
		var current_tick := 0
		
		if time > 8:
			time -= 8
		if int(time) != current_tick:
			current_tick = int(time)
			tick_physics_update(current_tick)
	
	func tick_physics_update(_tick):
		pass



