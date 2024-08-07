extends TileMap

var time: float
@export var depth: FastNoiseLite
@export var extra: FastNoiseLite
@export var chunk_size = Vector2(32, 32)
@export var bird: Node = preload("res://bird.tscn").instantiate()
@onready var slime = %slime

# Called when the node enters the scene tree for the first time.
func _ready():
	depth.seed = randi()
	extra.seed = randi()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	#generate_chunk(slime.position, time)


func generate_chunk(pos, time):
	var tile_pos = local_to_map(pos)
	for x in range(chunk_size.x):
		for y in range(chunk_size.y):
			var dpth = depth.get_noise_2d(tile_pos.x - chunk_size.x/2 + x, tile_pos.y - chunk_size.y/2 + y)*10
			var xtr = extra.get_noise_2d(tile_pos.x - chunk_size.x/2 + x, tile_pos.y - chunk_size.y/2 + y - time)*10
			set_cell(0, Vector2i(tile_pos.x - chunk_size.x/2 + x, tile_pos.y - chunk_size.y/2 + y), 0, Vector2(round((xtr+10)/10)+1, 1))
			#if dpth < -0.5: 
				#set_cell(1, Vector2i(tile_pos.x - chunk_size.x/2 + x, tile_pos.y - chunk_size.y/2 + y), 0, Vector2(round((dpth+10)/5), 0))
			
			

func spawn_bird(x, y, dpth, pos):
	if dpth > -0.5:
		if randi_range(0, 1000) < 1:
			var id = 0
			id += 1
			var new_bird = bird
			new_bird.name = "bird #" + str(id)
			add_sibling(new_bird)
			new_bird.position.x = pos.x - chunk_size.x/2 + x
			new_bird.position.y = pos.y - chunk_size.y/2 + y
