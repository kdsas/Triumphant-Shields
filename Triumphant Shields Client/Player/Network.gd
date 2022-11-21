extends Node


signal update_user_list

var user_name : String = "Default"
var user_color : String = "red"

var user_list : Dictionary
var server : NetworkedMultiplayerENet = NetworkedMultiplayerENet.new()
var host=false

func _ready() -> void:
	get_tree().connect("connected_to_server",self,"connected")
	get_tree().connect("server_disconnected",self,"server_disconnected")

#If we're successful connect to the server, go into the chatroom
func connected():
	print("connected to server")
	var compile_data : Array = [str(get_tree().get_network_unique_id()),user_name]
	rpc_unreliable_id(1,"update_user",compile_data)
	print("chatroom")
	
#Only run on the server
remote func update_user(user):
	user_list[str(user[0])] = user[1]
	emit_signal("update_user_list")
	rpc_unreliable("client_update",user_list)
	pass
	
remote func client_update(update_user_list):
	user_list = update_user_list
	emit_signal("update_user_list")

#Server just closed
func server_disconnected():
	print("server_disconnected")
	OS.alert('Server closed', 'Status')
	
func kick_player(net_id):
	rpc_id(1, "blocked")
	# Then disconnect that player from the server
	server.close_connection(1)

func create_server():
	server.create_server(3035,4)
	get_tree().set_network_peer(server)
	print("chatroom")

remote func blocked():
	print("You have been kicked from the server")
	


