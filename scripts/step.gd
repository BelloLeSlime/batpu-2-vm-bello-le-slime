extends Node2D

var step = 0

func _process(_delta: float) -> void:
	var binary = String.num_int64(step, 2).pad_zeros(10)
	for i in range(10):
		var bit_value = binary[9 - i]  # index inversé pour correspondre à BIT1..BIT10
		
		var sprite: Sprite2D = get_node("BIT%d" % (i + 1))
		
		if bit_value == "0":
			sprite.texture = load("res://assets/textures/redstone_lamp.png")
		else:
			sprite.texture = load("res://assets/textures/redstone_lamp_on.png")
	$Label.text = str(step)
