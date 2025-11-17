extends Node2D

var machine_code = """LDI r1 5
LDI r2 2
ADD r1 r2 r3
SUB r1 r2 r3
NOR r1 r2 r3
AND r1 r2 r3
XOR r1 r2 r3
RSH r1 r3"""

func _ready():
	for line in machine_code.split("\n"):
		print(line)
		var command = line.split(" ")[0]
		if command == "LDI":
			var register_adress = int(line.split(" ")[1].substr(1))
			var register_data = int(line.split(" ")[2])
			if register_adress != 0:
				globals.register_file[register_adress] = register_data & 0xFF
			print("r"+str(register_adress)+" : "+str(globals.register_file[register_adress]))
		elif command == "ADD":
			var register_adress1 = int(line.split(" ")[1].substr(1))
			var register_adress2 = int(line.split(" ")[2].substr(1))
			var register_adress_result = int(line.split(" ")[3].substr(1))
			var register_read1 = globals.register_file[register_adress1]
			var register_read2 = globals.register_file[register_adress2]
			if register_adress_result != 0:
				globals.register_file[register_adress_result] = (register_read1 + register_read2) & 0xFF
			print("r"+str(register_adress_result)+" : "+str(globals.register_file[register_adress_result]))
		elif command == "SUB":
			var register_adress1 = int(line.split(" ")[1].substr(1))
			var register_adress2 = int(line.split(" ")[2].substr(1))
			var register_adress_result = int(line.split(" ")[3].substr(1))
			var register_read1 = globals.register_file[register_adress1]
			var register_read2 = globals.register_file[register_adress2]
			if register_adress_result != 0:
				globals.register_file[register_adress_result] = (register_read1 - register_read2) & 0xFF
			print("r"+str(register_adress_result)+" : "+str(globals.register_file[register_adress_result]))
		elif command == "NOR":
			var register_adress1 = int(line.split(" ")[1].substr(1))
			var register_adress2 = int(line.split(" ")[2].substr(1))
			var register_adress_result = int(line.split(" ")[3].substr(1))
			var register_read1 = globals.register_file[register_adress1]
			var register_read2 = globals.register_file[register_adress2]
			if register_adress_result != 0:
				globals.register_file[register_adress_result] = (~(register_read1 | register_read2)) & 0xFF
			print("r"+str(register_adress_result)+" : "+str(globals.register_file[register_adress_result]))
		elif command == "AND":
			var register_adress1 = int(line.split(" ")[1].substr(1))
			var register_adress2 = int(line.split(" ")[2].substr(1))
			var register_adress_result = int(line.split(" ")[3].substr(1))
			var register_read1 = globals.register_file[register_adress1]
			var register_read2 = globals.register_file[register_adress2]
			if register_adress_result != 0:
				globals.register_file[register_adress_result] = (register_read1 & register_read2) & 0xFF
			print("r"+str(register_adress_result)+" : "+str(globals.register_file[register_adress_result]))
		elif command == "XOR":
			var register_adress1 = int(line.split(" ")[1].substr(1))
			var register_adress2 = int(line.split(" ")[2].substr(1))
			var register_adress_result = int(line.split(" ")[3].substr(1))
			var register_read1 = globals.register_file[register_adress1]
			var register_read2 = globals.register_file[register_adress2]
			if register_adress_result != 0:
				globals.register_file[register_adress_result] = (register_read1 ^ register_read2) & 0xFF
			print("r"+str(register_adress_result)+" : "+str(globals.register_file[register_adress_result]))
		elif command == "RSH":
			var register_adress1 = int(line.split(" ")[1].substr(1))
			var register_adress_result = int(line.split(" ")[2].substr(1))
			var register_read1 = globals.register_file[register_adress1]
			if register_adress_result != 0:
				globals.register_file[register_adress_result] = (~(register_read1 >> 1)) & 0xFF
			print("r"+str(register_adress_result)+" : "+str(globals.register_file[register_adress_result]))
