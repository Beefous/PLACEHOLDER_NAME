extends Node2D

@onready var video_drug = $"video-drugs"
@onready var ui = $ui
@onready var palette_replacer = $"palette-replacer"
@onready var crt_vhs = $"crt-vhs"
@export var visible_video_drug = true
@export var visible_ui = true
@export var visible_palette := true
@export var visible_crt := true

func _ready():
	video_drug.visible = visible_video_drug
	ui.visible = visible_ui
	palette_replacer.visible = visible_palette
	crt_vhs.visible = visible_crt
