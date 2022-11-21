extends Node


var network = NetworkedMultiplayerENet.new()
var gateway_api= MultiplayerAPI.new()
var port = 3030
var max_players = 16

var cert = load("res://Certificate/X509_Certificate.crt")
var key = load("res://Certificate/x509_Key.key")

func _ready():
	StartServer()
	
	
func _process(delta):
	if not custom_multiplayer.has_network_peer():
		return;
	custom_multiplayer.poll();	
	


func StartServer():
	network.set_dtls_enabled(true)
	network.set_dtls_key(key) 
	network.set_dtls_certificate(cert)
	network.create_server(port,max_players)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)
	print("Gateway Server started")
	#OS.alert('Gateway Server started', 'Gateway')
	network.connect("peer_connected", self, "_Peer_Connected")
	network.connect("peer_disconnected", self, "_Peer_Disconnected")
	

func _Peer_Connected(player_id):
	print("User"+ str(player_id)+ "Connected")
	#OS.alert("User"+ str(player_id)+ "Connected", 'Gateway')
	

func _Peer_Disconnected(player_id):
	print("User"+ str(player_id)+ "Disconnected")
	#OS.alert("User"+ str(player_id)+ "Disconnected", 'Gateway')
	
				


remote func CreateAccountRequest(username, password):
	var player_id = custom_multiplayer.get_rpc_sender_id()
	var valid_request= true
	if username == "":
		valid_request= false
	if password == "":
		valid_request= false
	if password.length() <=7:
		valid_request = false
	if valid_request ==false:
		ReturnCreateAccountRequest(valid_request,player_id,1)
	else:
		Authenticate.CreateAccount(username.to_lower(),password,player_id)
		

func ReturnCreateAccountRequest(result,player_id,message):
	rpc_id(player_id, "ReturnCreateAccountRequest", result, message)
	network.disconnect_peer(player_id)		
