extends Node2D

var buffer = []
var tiles = []

var tile_size = 16

func _ready():
	globals.reset_screen_buffer.connect(_reset_buffer)
	var x = 0
	var y = 0
	for row in range(32):
		var tiles_row = []
		for colomn in range(32):
			var tile = Sprite2D.new()
			add_child(tile)
			tile.texture = load("res://assets/textures/redstone_lamp.png")
			tile.position = Vector2(x, y)
			tile.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			tile.scale = Vector2(tile_size / 16.0, tile_size / 16.0)
			x += tile_size
			tiles_row.append(tile)
		x = 0
		y += tile_size
		tiles.append(tiles_row)
	
	for r in range(32):
		var row = []
		for c in range(32):
			row.append(0)
		buffer.append(row)
	
	for r in range(tiles.size()):
		var row = tiles[r]
		for t in range(row.size()):
			var tile = row[t]
			if buffer[r][t] == 0:
				tile.texture = load("res://assets/textures/redstone_lamp.png")
			else:
				tile.texture = load("res://assets/textures/redstone_lamp_on.png")

func _process(_delta):
	var pixel_x = globals.data_memory[240]
	var pixel_y = globals.data_memory[241]
	if globals.data_memory[242] == 0:
		buffer[31-pixel_y][pixel_x] = 1
		globals.data_memory[242] = 1
		print("Drawn pixel at "+str(pixel_x)+","+str(pixel_y))
	if globals.data_memory[243] == 0:
		buffer[31-pixel_y][pixel_x] = 0
		globals.data_memory[243] = 1
		print("Cleared pixel at "+str(pixel_x)+","+str(pixel_y))
	if globals.data_memory[245] == 0:
		for r in range(tiles.size()):
			var row = tiles[r]
			for t in range(row.size()):
				var tile = row[t]
				if buffer[r][t] == 0:
					tile.texture = load("res://assets/textures/redstone_lamp.png")
				else:
					tile.texture = load("res://assets/textures/redstone_lamp_on.png")
		globals.data_memory[245] = 1
		print("Pushed Buffer")
	if globals.data_memory[246] == 0:
		for r in range(buffer.size()):
			for c in range(buffer[r].size()):
				buffer[r][c] = 0
		globals.data_memory[246] = 1
		print("Cleared buffer")
	globals.data_memory[244] = buffer[31-pixel_y][pixel_x]

func _reset_buffer():
	for r in range(buffer.size()):
			for c in range(buffer[r].size()):
				buffer[r][c] = 0
