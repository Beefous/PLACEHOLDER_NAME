extends Label

@export var player: Character2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var preface_height = '00' if player.height <= 9 else '0' if player.height <= 99 else ''
	var preface_record = '00' if player.record <= 9 else '0' if player.record <= 99 else ''
	text =   'current: ' + preface_height + str(int(player.height)
		) + ' record:  ' + preface_record + str(int(player.record))
	pass
