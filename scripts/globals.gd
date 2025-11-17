extends Node

var machine_code = ""
var register_file = []
var data_memory = []
var running = false

func _ready():
	for i in range(16):
		register_file.append(0)
