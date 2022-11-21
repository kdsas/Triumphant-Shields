extends Node

var network = NetworkedMultiplayerENet.new()
var gateway_api= MultiplayerAPI.new()
var port = 3032
var max_players = 16

var gameserverlist ={}


func _ready():
	StartServer()
	
	
func _process(delta):
	if not custom_multiplayer.has_network_peer():
		return;
	custom_multiplayer.poll();	
	


func StartServer():
	network.create_server(port,max_players)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)
	print("GameServerHub started")
	#OS.alert('GameServerHub started', 'Authenticate')
	
	network.connect("peer_connected", self, "_Peer_Connected")
	network.connect("peer_disconnected", self, "_Peer_Disconnected")
	

func _Peer_Connected(gameserver_id):
	print("Game Server"+ str(gameserver_id) + "Connected")
	#OS.alert("Game Server"+ str(gameserver_id) + "Connected", 'Authenticate')
	gameserverlist["GameServer1"]=gameserver_id
	print(gameserverlist)
	
	

func _Peer_Disconnected(gameserver_id):
	print("Game Server"+ str(gameserver_id)+ "Disconnected")
	#OS.alert("Game Server"+ str(gameserver_id)+ "Disconnected", 'Authenticate')
	

