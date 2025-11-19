extends Node

@warning_ignore("unused_signal")
signal start
@warning_ignore("unused_signal")
signal stop
signal reset_screen_buffer
signal reset_step

var machine_code = ""
var register_file = []
var data_memory = []
var call_stack = []
var running = false
var speed = 100
var step = 0

func _ready():
	reset()

func reset():
	register_file = []
	data_memory = []
	emit_signal("reset_screen_buffer")
	emit_signal("reset_step")
	for i in range(16):
		register_file.append(0)
	for i in range(256):
		data_memory.append(0)
