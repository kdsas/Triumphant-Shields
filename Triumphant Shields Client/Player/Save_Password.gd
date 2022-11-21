extends Node


var p_password = "" setget set_password
const filepath = "user://password.data"

func _ready():
	load_password()
	pass

func load_password():
	var file = File.new()
	if not file.file_exists(filepath): return
	file.open(filepath, File.READ)
	p_password = file.get_var()
	file.close()
	pass

func save_password():
	var file = File.new()
	file.open(filepath, File.WRITE)
	file.store_var(p_password)
	file.close()
	pass

func set_password(new_value):
	p_password = new_value
	save_password()
	pass
