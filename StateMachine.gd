class_name StateMachine
extends Node2D

@export var my_owner: Node
var states:= Dictionary()
var current_state: State

var pause := false

var keys: Array

func _init(_owner: Node):
	my_owner = _owner

func _ready():
	on_ready()
	if states.values()[0]:
		
		keys = states.keys()

func initial_state(state_name: String):
	change_state(state_name)

func on_ready(): pass

func SM_process(delta):
	process(delta)
	if current_state:
		current_state.update(delta)
		if current_state.update(delta):
			change_state(current_state.update(delta))

func process(_delta): pass 

func SM_physics_process(delta):
	physics_process(delta)
	if current_state:
		current_state.physics_update(delta)

func physics_process(_delta): pass

func add_state(state_name: String,new_state: State):
	var state = new_state
	state.machine = self
	state.machine_owner = my_owner
	states[state_name] = new_state
	print(state_name)

func change_state(state_name: String):
	
	if states.has(state_name):
		if current_state:
			current_state.exit()
		current_state = states.get(state_name)
		current_state.enter()
		print("changed to ",state_name)
	else: print('there is no state named ', state_name)
