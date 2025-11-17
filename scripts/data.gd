extends ScrollContainer

func _ready() -> void:
	$Label.text = ""
	var adress = 0
	for i in range(64):
		$Label.text += "d" + str(adress).pad_zeros(3) + " : 0 | d" + str(adress + 1).pad_zeros(3) + " : 0 | d" + str(adress + 2).pad_zeros(3) + " : 0 | d"+ str(adress+3).pad_zeros(3) + " : 0\n"
		adress += 4
