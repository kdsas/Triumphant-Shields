extends Node

var level = 1 setget set_level
const filepath = "user://level.data"

func _ready():
	load_level()
	pass

func load_level():
	var file = File.new()
	if not file.file_exists(filepath): return
	file.open(filepath, File.READ)
	level = file.get_var()
	file.close()
	pass

func save_level():
	var file = File.new()
	file.open(filepath, File.WRITE)
	file.store_var(level)
	file.close()
	pass

func set_level(new_value):
	level = new_value
	save_level()
	pass
