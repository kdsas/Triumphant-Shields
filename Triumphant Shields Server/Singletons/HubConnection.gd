extends Node

var network = NetworkedMultiplayerENet.new()
var gateway_api= MultiplayerAPI.new()
var port = 3032
var ip = "68.89.68.154"

onready var gameserver =get_node("/root/Server")


func _ready():
	ConnectToServer()
	
	
func _process(delta):
	if get_custom_multiplayer()==null:
		return
	if not custom_multiplayer.has_network_peer():
		return;
	custom_multiplayer.poll();
	


func ConnectToServer():
	network.create_client(ip, port)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)

	
	network.connect("connection_failed", self, "_OnConnectionFailed")
	network.connect("connection_succeeded", self, "_OnConnectionSucceeded")
	
	
func _OnConnectionSucceeded():
	print("Successfully connected to Game Server Hub")
	OS.alert("Successfully connected to Game Server Hub", 'Server')

		


func _OnConnectionFailed():
	print("Failed to connect to Game Server Hub")
	OS.alert("Failed to connect to Game Server Hub", 'Server')
	

