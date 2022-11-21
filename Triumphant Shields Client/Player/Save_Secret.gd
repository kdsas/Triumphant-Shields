extends Node


var p_secret = "" setget set_psecret
const filepath = "user://secret.data"

func _ready():
	load_psecret()
	pass

func load_psecret():
	var file = File.new()
	if not file.file_exists(filepath): return
	file.open(filepath, File.READ)
	p_secret = file.get_var()
	file.close()
	pass

func save_psecret():
	var file = File.new()
	file.open(filepath, File.WRITE)
	file.store_var(p_secret)
	file.close()
	pass

func set_psecret(new_value):
	p_secret = new_value
	save_psecret()
	pass
