extends Node


var p_ban = "ban" setget set_pban
const filepath = "user://ban.data"

func _ready():
	load_pban()
	pass

func load_pban():
	var file = File.new()
	if not file.file_exists(filepath): return
	file.open(filepath, File.READ)
	p_ban = file.get_var()
	file.close()
	pass

func save_pban():
	var file = File.new()
	file.open(filepath, File.WRITE)
	file.store_var(p_ban)
	file.close()
	pass

func set_pban(new_value):
	p_ban= new_value
	save_pban()
	pass
