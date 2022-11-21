extends Node

var network= NetworkedMultiplayerENet.new()
var port = 3031
var max_servers = 5



func _ready():
	StartServer()
	
	
func StartServer():
	network.create_server(port, max_servers)
	get_tree().set_network_peer(network)
	$ColorRect/authenticationLabel.text="Authentication Server Started"
	
	network.connect("peer_connected", self, "_Peer_Connected")
	network.connect("peer_disconnected", self, "_Peer_Disconnected")
	
	
func _Peer_Connected(gateway_id):
	$ColorRect/authenticationLabel.text="Gateway"+ str(gateway_id)+"Connected"
	
	


func _Peer_Disconnected(gateway_id):
	$ColorRect/authenticationLabel.text="Gateway"+ str(gateway_id)+"Disconnected"	
	
	
remote func AuthenticatePlayer(username, password, player_id):
	$ColorRect/authenticationLabel.text="Authentication request received"
	var token
	var gateway_id = get_tree().get_rpc_sender_id()
	var result
	$ColorRect/authenticationLabel.text="Starting authentication"
	if not PlayerData.PlayerIDs.has(username):
		$ColorRect/authenticationLabel.text= "User not recognized"
		result =false
	elif not PlayerData.PlayerIDs[username].Password==password:
		result=false	
	else:
		$ColorRect/authenticationLabel.text="Successful authentication"
		randomize()
		token = str(randi()).sha256_text() + str(OS.get_unix_time())
		var gameserver= "GameServer1"
		GameServers.DistributeLoginToken(token,gameserver)
		result= true
		$ColorRect/authenticationLabel.text="Authentication result sent to gateway server"
		rpc_id(gateway_id,"AuthenticationResults", result, player_id, token)

		
remote func CreateAccount(username,password,player_id):
	var gateway_id = get_tree().get_rpc_sender_id()
	var result
	var message
	if PlayerData.PlayerIDs.has(username):
		result=false
		message=2
	else:
		result=true
		message=3
		var salt = GenerateSalt()
		var token
		token = str(randi()).sha256_text() + str(OS.get_unix_time())
		print("Token: "+token)
		randomize()
		var hashed_password= GenerateHashedPassword(password, salt)
		PlayerData.PlayerIDs[username]={"Password":password, "Salt":hashed_password}
		PlayerData.SavePlayerIDs()
		
	rpc_id(gateway_id, "CreateAccountResults", result, player_id, message)	
	

func GenerateSalt():
	randomize()
	var salt = str(randi()).sha256_text()
	print("Salt:"+salt)
	return salt	

func GenerateHashedPassword(password,salt):
	print(str(OS.get_system_time_msecs()))
	var hashed_password=password
	var rounds= pow(2,18) # Hash password 2 to the 18th power times
	print("Hashed password as input:"+ hashed_password)
	while rounds > 0:#Countdown from 18
		hashed_password= (hashed_password+salt).sha256_text()
		#print("password @ round:"+str(rounds)+"is:"+hashed_password)
		rounds-=1
	print("Final hashed password:"+ hashed_password)
	print(str(OS.get_system_time_msecs()))
	return hashed_password	
