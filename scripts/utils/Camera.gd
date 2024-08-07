extends Camera2D


var res := 256

func _on_left_body_entered(body):
	if body.is_in_group("player"): position.x -= res

func _on_up_body_entered(body):
	if body.is_in_group("player"): position.y -= res

func _on_down_body_entered(body):
	if body.is_in_group("player"): position.y += res

func _on_right_body_entered(body):
	if body.is_in_group("player"): position.x += res
