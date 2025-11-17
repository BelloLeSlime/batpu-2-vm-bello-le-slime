extends Node2D

var machine_code = """LDI r1 1
LDI r2 1"""

func _ready():
	for line in machine_code.split("\n"):
		print(line)
		if line.split(" ")[0] == "LDI":
			var register_adress = int(line.split(" ")[1].substr(1))
			var register_data = int(line.split(" ")[2])
			if register_adress != 0:
				globals.register_file[register_adress] = register_data
			print("r"+str(register_adress)+" : "+str(globals.register_file[register_adress]))
