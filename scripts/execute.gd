extends Node2D




var flags = {
		"zero" : false,
		"carry" : false
}
var ldi_mapping = {
	"pixel_x": 240,
	"pixel_y": 241,
	"draw_pixel": 242,
	"clear_pixel": 243,
	"load_pixel": 244,
	"buffer_screen": 245,
	"clear_buffer_screen": 246,
	"write_char": 247,
	"buffer_chars": 248,
	"clear_chars_buffer": 249,
	"show_number": 250,
	"clear_number": 251,
	"signed_mode": 252,
	"unsigned_mode": 253,
	"rng": 254,
	"controller_input": 255
}

func update_flags(value):
	if value & 0xFF == 0:
		flags["zero"] = true
	else:
		flags["zero"] = false
	if value > 255 or value < 0:
		flags["carry"] = true
	else:
		flags["carry"] = false
	print("flags - zero : "+str(flags["zero"])+", carry : "+str(flags["carry"]))

func _ready() -> void:
	globals.start.connect(_start)
	globals.stop.connect(_stop)

func _start():
	
	var machine_code = globals.machine_code
	
	var lines = machine_code.split("\n")
	
	var labels = {}
	for i in range(lines.size()):
		var l = lines[i].strip_edges()
		if l.begins_with("."):
			labels[l] = i
	
	var step = 0
	while step < lines.size():
		globals.step = step
		$Delta.start()
		var line = lines[step]
		print(line)
		var command = "NOP"
		if not line == "":
			command = line.split(" ")[0]
		if command == "LDI":
			var register_adress = int(line.split(" ")[1].substr(1))
			var register_data_str = line.split(" ")[2]
			var register_data = 0
			if register_data_str.is_valid_int():
				register_data = int(register_data_str)
			else:
				if ldi_mapping.has(register_data_str):
					register_data = ldi_mapping[register_data_str]
				else:
					print("ParserError at line "+str(step)+" : '"+line+"'. Constant '"+register_data_str+"' isn't defined.")
					break
			
			if register_adress != 0:
				globals.register_file[register_adress] = register_data & 0xFF
			print("r"+str(register_adress)+" : "+str(globals.register_file[register_adress]))
		elif command == "ADD":
			var register_adress1 = int(line.split(" ")[1].substr(1))
			var register_adress2 = int(line.split(" ")[2].substr(1))
			var register_adress_result = int(line.split(" ")[3].substr(1))
			var register_read1 = globals.register_file[register_adress1]
			var register_read2 = globals.register_file[register_adress2]
			var result = register_read1 + register_read2
			update_flags(result)
			if register_adress_result != 0:
				globals.register_file[register_adress_result] = result & 0xFF
			print("r"+str(register_adress_result)+" : "+str(globals.register_file[register_adress_result]))
		elif command == "SUB":
			var register_adress1 = int(line.split(" ")[1].substr(1))
			var register_adress2 = int(line.split(" ")[2].substr(1))
			var register_adress_result = int(line.split(" ")[3].substr(1))
			var register_read1 = globals.register_file[register_adress1]
			var register_read2 = globals.register_file[register_adress2]
			var result = register_read1 - register_read2
			update_flags(result)
			if register_adress_result != 0:
				globals.register_file[register_adress_result] = result & 0xFF
			print("r"+str(register_adress_result)+" : "+str(globals.register_file[register_adress_result]))
		elif command == "NOR":
			var register_adress1 = int(line.split(" ")[1].substr(1))
			var register_adress2 = int(line.split(" ")[2].substr(1))
			var register_adress_result = int(line.split(" ")[3].substr(1))
			var register_read1 = globals.register_file[register_adress1]
			var register_read2 = globals.register_file[register_adress2]
			var result = (~(register_read1 | register_read2)) & 0xFF
			update_flags(result)
			if register_adress_result != 0:
				globals.register_file[register_adress_result] = result
			print("r"+str(register_adress_result)+" : "+str(globals.register_file[register_adress_result]))
		elif command == "AND":
			var register_adress1 = int(line.split(" ")[1].substr(1))
			var register_adress2 = int(line.split(" ")[2].substr(1))
			var register_adress_result = int(line.split(" ")[3].substr(1))
			var register_read1 = globals.register_file[register_adress1]
			var register_read2 = globals.register_file[register_adress2]
			var result = (register_read1 & register_read2) & 0xFF
			update_flags(result)
			if register_adress_result != 0:
				globals.register_file[register_adress_result] = result
			print("r"+str(register_adress_result)+" : "+str(globals.register_file[register_adress_result]))
		elif command == "XOR":
			var register_adress1 = int(line.split(" ")[1].substr(1))
			var register_adress2 = int(line.split(" ")[2].substr(1))
			var register_adress_result = int(line.split(" ")[3].substr(1))
			var register_read1 = globals.register_file[register_adress1]
			var register_read2 = globals.register_file[register_adress2]
			var result = (register_read1 ^ register_read2) & 0xFF
			update_flags(result)
			if register_adress_result != 0:
				globals.register_file[register_adress_result] = result
			print("r"+str(register_adress_result)+" : "+str(globals.register_file[register_adress_result]))
		elif command == "RSH":
			var register_adress1 = int(line.split(" ")[1].substr(1))
			var register_adress_result = int(line.split(" ")[2].substr(1))
			var register_read1 = globals.register_file[register_adress1]
			var result = (register_read1 >> 1) & 0xFF
			update_flags(result)
			if register_adress_result != 0:
				globals.register_file[register_adress_result] = result
			print("r"+str(register_adress_result)+" : "+str(globals.register_file[register_adress_result]))
		elif command == "ADI":
			var register_adress = int(line.split(" ")[1].substr(1))
			var register_read = globals.register_file[register_adress]
			var imediate = int(line.split(" ")[2])
			var result = (register_read + imediate) & 0xFF
			update_flags(result)
			if register_adress != 0:
				globals.register_file[register_adress] = result
			print("r"+str(register_adress)+" : "+str(globals.register_file[register_adress]))
		elif command == "JMP":
			var jump_to_step = line.split(" ")[1]
			step = labels[jump_to_step]-1
		elif command == "BRH":
			var condition = line.split(" ")[1]
			var jump_to_step = line.split(" ")[2]
			var jump_to_line = labels[jump_to_step]
			if condition in ["zero", "notzero", "carry", "notcarry"]:
				if (condition == "zero" and flags["zero"]) or (condition == "notzero" and not flags["zero"]) or (condition == "carry" and flags["carry"]) or (condition == "notcarry" and not flags["carry"]):
					step = jump_to_line-1
		elif command == "CAL":
			globals.call_stack .append(step+1)
			var jump_to_step = line.split(" ")[1]
			step = labels[jump_to_step]-1
		elif command == "RET":
			step = globals.call_stack[globals.call_stack.size()-1]-1
			globals.call_stack.pop_at(globals.call_stack.size()-1)
		elif command == "STR":
			var register_data_adress_adress = int(line.split(" ")[1])
			var data_adress = globals.register_file[register_data_adress_adress]
			var register_data_data_adress = int(line.split(" ")[2])
			var data_data = globals.register_file[register_data_data_adress]
			var offset = 0
			if line.split(" ").size() == 4:
				offset = int(line.split(" ")[3])
			data_adress = (data_adress + offset) & 0xFF
			globals.data_memory[data_adress] = data_data
			print("d"+str(data_adress)+" : "+str(globals.data_memory[data_adress]))
		elif command == "LOD":
			var register_data_adress_adress = int(line.split(" ")[1])
			var data_adress = globals.register_file[register_data_adress_adress]
			var register_adress = int(line.split(" ")[2])
			var offset = 0
			if line.split(" ").size() == 4:
				offset = int(line.split(" ")[3])
			data_adress = (data_adress + offset) & 0xFF
			var register_data = globals.data_memory[data_adress]
			globals.register_file[register_adress] = register_data
			print("r"+str(register_adress)+" : "+str(globals.register_file[register_adress]))
		elif command == "CMP":
			var register_adress1 = int(line.split(" ")[1].substr(1))
			var register_adress2 = int(line.split(" ")[2].substr(1))
			var register_adress_result = 0
			var register_read1 = globals.register_file[register_adress1]
			var register_read2 = globals.register_file[register_adress2]
			var result = register_read1 - register_read2
			update_flags(result)
			if register_adress_result != 0:
				globals.register_file[register_adress_result] = result & 0xFF
			print("r"+str(register_adress_result)+" : "+str(globals.register_file[register_adress_result]))
		elif command == "MOV":
			var register_adress1 = int(line.split(" ")[1].substr(1))
			var register_adress_result = int(line.split(" ")[2].substr(1))
			var register_read1 = globals.register_file[register_adress1]
			var register_read2 = 0
			var result = register_read1 + register_read2
			update_flags(result)
			if register_adress_result != 0:
				globals.register_file[register_adress_result] = result & 0xFF
			print("r"+str(register_adress_result)+" : "+str(globals.register_file[register_adress_result]))
		elif command == "LSH":
			var register_adress1 = int(line.split(" ")[1].substr(1))
			var register_adress_result = int(line.split(" ")[2].substr(1))
			var register_read1 = globals.register_file[register_adress1]
			var result = 2 * register_read1
			update_flags(result)
			if register_adress_result != 0:
				globals.register_file[register_adress_result] = result & 0xFF
			print("r"+str(register_adress_result)+" : "+str(globals.register_file[register_adress_result]))
		elif command == "INC":
			var register_adress = int(line.split(" ")[1].substr(1))
			var register_read = globals.register_file[register_adress]
			var imediate = 1
			var result = register_read + imediate
			update_flags(result)
			if register_adress != 0:
				globals.register_file[register_adress] = result & 0xFF
			print("r"+str(register_adress)+" : "+str(globals.register_file[register_adress]))
		elif command == "DEC":
			var register_adress = int(line.split(" ")[1].substr(1))
			var register_read = globals.register_file[register_adress]
			var imediate = -1
			var result = register_read + imediate
			update_flags(result)
			if register_adress != 0:
				globals.register_file[register_adress] = result & 0xFF
			print("r"+str(register_adress)+" : "+str(globals.register_file[register_adress]))
		elif command == "NOT":
			var register_adress1 = int(line.split(" ")[1].substr(1))
			var register_adress_result = int(line.split(" ")[2].substr(1))
			var register_read1 = globals.register_file[register_adress1]
			var register_read2 = 0
			var result = (~(register_read1 | register_read2)) & 0xFF
			update_flags(result)
			if register_adress_result != 0:
				globals.register_file[register_adress_result] = result
			print("r"+str(register_adress_result)+" : "+str(globals.register_file[register_adress_result]))
		elif command == "NEG":
			var register_adress2 = int(line.split(" ")[1].substr(1))
			var register_adress_result = int(line.split(" ")[2].substr(1))
			var register_read1 = 0
			var register_read2 = globals.register_file[register_adress2]
			var result = register_read1 - register_read2
			update_flags(result)
			if register_adress_result != 0:
				globals.register_file[register_adress_result] = result & 0xFF
			print("r"+str(register_adress_result)+" : "+str(globals.register_file[register_adress_result]))
		elif command == "NOP":
			pass
		elif command == "HLT":
			break
		elif command[0] == "/" or command[0] == "#" or command[0] == ";" or command[0] == ".":
				pass
		else:
			print("SyntaxError at line "+str(step)+" : '"+line+"'. '"+command+"' is not a valid instruction.")
			break
		step += 1
		var delta  = 1-$Delta.time_left
		var speed = globals.speed
		if delta <= 1.0/speed:
			$Timer.wait_time = 1.0 / speed - delta
		else:
			print("Performance Issues!")
		$Timer.start()
		await $Timer.timeout
	globals.running = false

func _stop():
	pass
