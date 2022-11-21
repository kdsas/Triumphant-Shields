extends Node

var shields = 0 setget set_shields
const filepath = "user://shields.data"

func _ready():
	load_shields()
	pass

func load_shields():
	var file = File.new()
	if not file.file_exists(filepath): return
	file.open(filepath, File.READ)
	shields = file.get_var()
	file.close()
	pass

func save_shields():
	var file = File.new()
	file.open(filepath, File.WRITE)
	file.store_var(shields)
	file.close()
	pass

func set_shields(new_value):
	shields = new_value
	save_shields()
	pass
