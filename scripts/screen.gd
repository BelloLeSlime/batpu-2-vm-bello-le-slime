extends Node2D

var pixels = []
var tiles = []

var tile_size = 16

func _ready():
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
		pixels.append(row)
	
	for r in range(tiles.size()):
		var row = tiles[r]
		for t in range(row.size()):
			var tile = row[t]
			if pixels[r][t] == 0:
				tile.texture = load("res://assets/textures/redstone_lamp.png")
			else:
				tile.texture = load("res://assets/textures/redstone_lamp_on.png")
