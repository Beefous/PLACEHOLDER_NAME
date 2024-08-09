extends Area2D
class_name RoomArea2D

#@export var paint_mix_animator: AnimationPlayer
@onready var paint_mix_animator = %AnimationPlayer


func _on_body_entered(body):
	if body.is_in_group('player'):
		paint_mix_animator.play('enter')
	print('body entered')

func _on_body_exited(body):
	if body.is_in_group('player'):
		paint_mix_animator.play('exit')
	print("body exited")
