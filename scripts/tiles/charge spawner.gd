extends Node2D

@onready var timer = $Timer

@export var wait_time := 3.0

var charge = Charge.new()


func _ready():
	add_child(charge)


func _on_child_exiting_tree(node):
	if node is Charge:
		timer.start(wait_time)


func _on_timer_timeout():
	var new_charge = Charge.new()
	add_child(new_charge)
