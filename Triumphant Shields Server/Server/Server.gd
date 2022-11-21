extends Node

var network = NetworkedMultiplayerENet.new()
var port = 3029
var max_players = 16
var players = {}
var ready_players = 0




func _ready():
	start_server()

	
func start_server():
	network.create_server(port, max_players)
	get_tree().set_network_peer(network)
	network.connect("peer_connected", self, "_Peer_Connected")
	network.connect("peer_disconnected", self, "_Peer_Disconnected")
	
	$ColorRect/Label.text="Server Started"
	
	
func _Peer_Connected(player_id):
	$ColorRect/Label.text="Player: " + str(player_id) + " Connected"
	
	
	

func _Peer_Disconnected(player_id):
	$ColorRect/Label.text="Player: " + str(player_id) + " Disconnected"
	players.erase(player_id)
	
	
remote func kicked():
	
	print(" kicked ")

remote func ban():
	
	print("banned ")


remote func send_player_info(id, player_data):
	players[id] = player_data
	rset("players", players)
	rpc("update_waiting_room")
	



	
remote func load_world():
	ready_players += 1
	if players.size() > 1 and ready_players >= players.size():
		rpc("start_game")
		var world = preload("res://World/World.tscn").instance()
		get_tree().get_root().add_child(world)
		
remote func game_ended():
	if has_node("/root/World"):
		get_tree().get_root().get_node("World").queue_free()
	ready_players = 0

		


remote func message_send(player_name, message):
	rpc("message_received", player_name, message)




	

