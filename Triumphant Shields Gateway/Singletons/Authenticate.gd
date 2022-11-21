extends Node

var network= NetworkedMultiplayerENet.new()
var ip = "68.89.68.154"
var port = 3031


func _ready():
	ConnectToServer()
	
	
func ConnectToServer():
	network.create_client(ip,port)
	get_tree().set_network_peer(network)
	
	network.connect("connection_failed", self, "_OnConnectionFailed")
	network.connect("connection_succeeded", self, "_OnConnectionSucceeded")	


func _OnConnectionFailed():
	print("Failed to connect to authentication server")
	OS.alert('Failed to connect to authentication server', 'Gateway')
	
	
	
	
func _OnConnectionSucceeded():
	print("Successfully connected to authentication server")
	OS.alert('Successfully connected to authentication server', 'Gateway')
	
	
func AuthenticatePlayer(username, password,player_id):
	rpc_id(1,"AuthenticatePlayer", username,password,player_id)



func CreateAccount(username,password,player_id):
	print("Sending out create account request")
	rpc_id(1,"CreateAccount", username, password, player_id)
	

remote func CreateAccountResults(result,player_id, message):
	print("Results received and replying to player's create account request")
	Gateway.ReturnCreateAccountRequest(result,player_id,message)	
