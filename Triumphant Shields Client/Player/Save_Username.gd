extends Node


var p_username = "" setget set_pusername
const filepath = "user://username.data"

func _ready():
	load_pusername()
	pass

func load_pusername():
	var file = File.new()
	if not file.file_exists(filepath): return
	file.open(filepath, File.READ)
	p_username = file.get_var()
	file.close()
	pass

func save_pusername():
	var file = File.new()
	file.open(filepath, File.WRITE)
	file.store_var(p_username)
	file.close()
	pass

func set_pusername(new_value):
	p_username = new_value
	save_pusername()
	pass
