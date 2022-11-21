extends Node

const DEFAULT_IP = "68.89.68.154"
const DEFAULT_PORT = 3029
var network = NetworkedMultiplayerENet.new()





var local_player_id = 0
sync var players = {}
sync var player_data = {}



var addresses = []
var ip1


var selected_IP= "68.89.68.154"
var selected_port= 3029

func _ready():
	for ip in IP.get_local_addresses():
		   if ip.begins_with("10.") or ip.begins_with("172.16.") or ip.begins_with("192.168."):
			   ip1=ip
			   print(ip1)
			   addresses.push_back(ip)
	match Global.ban_reason:
		Global.BanReason.not_banned:
			print("not banned")
	
	match Global.kick_reason:
		Global.KickReason.not_kicked:
			print("not kicked")			

func _readyNow():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
	  

func _process(delta):
	Data.Data_file["Player_ip"]={"IP":str(ip1)} #Gets IP
	Data.SaveData()
	if (SaveBan.p_ban=="banned"): #Checks for ban
	  get_tree().change_scene("res://GUI/BanGUI.tscn")
	  yield(get_tree().create_timer(4),"timeout")
	  get_tree().quit()

		
	

func _connect_to_server():
	network.create_client(selected_IP, selected_port)
	get_tree().set_network_peer(network)
	
	
func _connection():
	network.connect("connection_failed",self, "_OnConnectionFailed")
	network.connect("connection_succeeded",self, "_OnConnectionSucceeded")	  
	
func _player_connected(id):
	print("Player: " + str(id) + " Connected")

	
func _player_disconnected(id):
	print("Player: " + str(id) + " Disconnected")
	if get_tree().get_root().has_node("World"):
		get_tree().get_root().get_node("World").delete_player(id)
	
func _connected_ok():
	print("Successfully connected to server")
	OS.alert('Successfully connected to server', 'Connection')
	
	register_player()
	rpc_id(1, "send_player_info", local_player_id, player_data)
	
	
	

func kicked(id, reason):
	# First, remote call the function
	rpc_id(1, "kicked")
	network.close_connection(1)
	
	
func ban(id, reason):
	# First, remote call the function
	rpc_id(1, "ban")
	network.close_connection(int(ip1))


func _OnConnectionFailed():
	print("Failed to connect to game server")
	OS.alert('Failed to connect to game server', 'Connection')

func _OnConnectionSucceeded():
	_connected_ok()
	


func _connected_fail():
	print("Failed to connect")
	OS.alert('Failed to connect', 'Connection')
	
func _server_disconnected():
	print("Server Disconnected")
	OS.alert('Server Disconnected', 'Connection')
	
func register_player():
	local_player_id = get_tree().get_network_unique_id()
	player_data = Save.save_data
	players[local_player_id] = player_data
	


func load_game():
	rpc_id(1, "load_world")
	
	
sync func start_game():
	var world = preload("res://World/World.tscn").instance()
	get_tree().get_root().add_child(world)
	var chatmenu = preload("res://GUI/Chat.tscn").instance()
	get_tree().get_root().add_child(chatmenu)
	get_tree().get_root().get_node("Join").queue_free()
	
	
	


func end_game():
	rpc_id(1, "game_ended")
	var world = get_node("/root/World")
	if has_node("/root/World"):
		world.queue_free()
	get_tree().get_root().get_node("Chat").queue_free()
	get_tree().change_scene("res://GUI/GameDone.tscn")
	network.close_connection()
	get_tree().disconnect("connected_to_server", self, "_connected_ok")
	get_tree().set_network_peer(null)
	

sync func update_waiting_room():
	get_tree().call_group("WaitingRoom", "refresh_players", players)
	



func add_to_chat(message):
	rpc_id(1, "message_send", players[local_player_id]["Player_name"], message)
	
sync func message_received(player_name, data):
	get_tree().get_root().get_node("Chat").message(player_name, data)
	


