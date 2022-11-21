extends Node

var Data_file


func _ready():
	var Data_file_file= File.new()
	Data_file_file.open_encrypted_with_pass("res://Data.json", File.READ, "williams") #Read encrypted file
	var Data_file_json = JSON.parse(Data_file_file.get_as_text())
	Data_file=Data_file_json.result
	Data_file_file.close()
	
	
func SaveData():
	var save_file= File.new()
	save_file.open_encrypted_with_pass("res://Data.json", File.WRITE, "williams") #Encryption makes information in .json file unreadable to users
	save_file.store_line(to_json(Data_file))
	save_file.close()	
