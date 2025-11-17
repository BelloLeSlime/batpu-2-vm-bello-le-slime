extends CanvasLayer

@onready var import_button: TextureButton = $Import
@onready var file_dialog: FileDialog = $AsFileDialog

func _process(_delta):
	$Speed.text = str(int($SpeedScrollBar.value)) + "\nips"

func _ready() -> void:
	file_dialog.file_selected.connect(Callable(self, "_on_file_selected"))

func _on_import_pressed() -> void:
	file_dialog.popup_centered()

func _on_file_selected(path: String) -> void:
	print("Fichier importé :", path)
	var file := FileAccess.open(path, FileAccess.READ)
	var content := file.get_as_text()
	var file_name = path.get_file()
	var file_basename = file_name.get_basename()
	$Name.text = file_basename
	$Code.text = content

func _on_export_pressed() -> void:
	var popup := PopupPanel.new()
	add_child(popup)
	
	var vb := VBoxContainer.new()
	popup.add_child(vb)
	
	# Titre
	var title = Label.new()
	title.text = "Export As..."
	vb.add_child(title)
	
	# Boutons export
	var btn_as := Button.new()
	btn_as.text = "Assembly File (.as)"
	btn_as.pressed.connect(Callable(self, "_export_as"))
	vb.add_child(btn_as)
	
	var btn_mc := Button.new()
	btn_mc.text = "Binary Code (.mc)"
	btn_mc.pressed.connect(Callable(self, "_export_mc"))
	vb.add_child(btn_mc)
	
	var btn_sch := Button.new()
	btn_sch.text = "Minecraft Schematic (.schematic)"
	btn_sch.pressed.connect(Callable(self, "_export_schem"))
	vb.add_child(btn_sch)
	
	# Bouton Cancel
	var btn_cancel := Button.new()
	btn_cancel.text = "Cancel"
	btn_cancel.pressed.connect(func():
		popup.hide()  # cache la popup
		popup.queue_free()  # supprime le node de la scène si besoin
	)
	vb.add_child(btn_cancel)
	
	popup.popup_centered()

func _dir_selected(path):
	var file = FileAccess.open(path, FileAccess.WRITE)
	var content = $Code.text
	if file:
		file.store_string(content)
		file.close()
	else:
		push_error("Cannot find file at : " + path)
	
func export_as():
	var fd = FileDialog.new()
	add_child(fd)
	fd.access = FileDialog.ACCESS_FILESYSTEM
	fd.mode = FileDialog.FILE_MODE_SAVE_FILE
	fd.filters = ["*.as ; Assembly File"]
	fd.file_selected.connect(Callable(self, "_dir_selected"))
	fd.popup_centered()

# ----- Export .mc -----
func _export_mc():
	_export_with_python("mc")

# ----- Export .schematic -----
func _export_schem():
	_export_with_python("schem")

# ----- Fonction commune pour mc/schematic -----
func _export_with_python(format: String):
	var res = ProjectSettings.globalize_path("res://")
	var program_name = $Name.text
	var programs_dir = res + "assembler/programs/"
	
	# 1️⃣ Sauvegarder le .as dans programs_dir
	var as_path = programs_dir + program_name + ".as"
	var dir := DirAccess.open(res)
	if dir == null:
		return

	dir.make_dir_recursive(res+"assembler/programs")
	var file = FileAccess.open(as_path, FileAccess.WRITE)
	file.store_string($Code.text)
	file.close()
	print("Saved .as to:", as_path)
	
	var python_path = res+"assembler/venv/Scripts/python.exe"
	var main_py = res+"assembler/main.py"
	var args = [main_py, program_name]
	var output := []
	var exit_code := OS.execute(python_path, args, output, true)
	print("OUTPUT:", output)
	print("Python script exited with code:", exit_code)

	
	var generated_path = ""
	if format == "mc":
		generated_path = programs_dir + program_name + ".mc"
	else:
		generated_path = programs_dir + program_name + "program.schem"
	
	var fd := FileDialog.new()
	fd.access = FileDialog.ACCESS_FILESYSTEM
	fd.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	fd.filters = ["*." + format]
	add_child(fd)
	
	fd.file_selected.connect(func(dest_path):
		if FileAccess.file_exists(generated_path):
			var dest_dir_path = dest_path.get_base_dir()
			var dir_inner = DirAccess.open(dest_dir_path)
			if dir_inner:
				var err = dir_inner.copy(generated_path, dest_path)
				if err == OK:
					print("Copied", generated_path, "to", dest_path)
				else:
					print("Error copying file:", err)
			else:
				print("Could not open / for copying")
		else:
			print("Generated file not found:", generated_path)
)
	fd.popup_centered()
