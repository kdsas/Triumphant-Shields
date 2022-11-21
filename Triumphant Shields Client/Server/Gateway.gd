extends Node

var network = NetworkedMultiplayerENet.new()

var gateway_api= MultiplayerAPI.new()
var username
var password
var new_account = false

var ip= "68.89.68.154"
var port= 3030
var cert = load("res://Resourses/Certificate/X509_Certificate.crt")

func _ready():
	pass
	

func _process(delta):
	if get_custom_multiplayer()==null:
		return
	if not custom_multiplayer.has_network_peer():
		return;
	custom_multiplayer.poll();
	
	
func ConnectToLoginServer(_username,_password, _new_account):
	 network = NetworkedMultiplayerENet.new()
	 gateway_api= MultiplayerAPI.new()
	 network.set_dtls_enabled(true)
	 network.set_dtls_verify_enabled(false) 
	 network.set_dtls_certificate(cert)
	 username = _username
	 password = _password
	 new_account = _new_account
	 network.create_client(ip, port)
	 set_custom_multiplayer(gateway_api)
	 custom_multiplayer.set_root_node(self)
	 custom_multiplayer.set_network_peer(network)
	 network.connect("connection_failed", self, "_OnConnectionFailed")
	 network.connect("connection_succeeded", self, "_OnConnectionSucceeded")

	
		 
 
func _OnConnectionFailed():
	print("Failed to connect to login server")
	var login_canvas = get_node("/root/LoginScreenCanvasLayer")
	if has_node("/root/LoginScreenCanvasLayer"):
		login_canvas.response_label.text="Server offline"
	#get_node("../GUI/LoginScreenCanvasLayer").login_button.disabled=false
	#get_node("../GUI/LoginScreenCanvasLayer").create_button.disabled=false
	#get_node("../GUI/LoginScreenCanvasLayer").register_button.disabled=false

	
func _OnConnectionSucceeded():
	print("Successfully connected to login server")
	if new_account ==true:
		RequestCreateAccount()
	else:	
		 print("Login")
		
func RequestCreateAccount():
	print("Requesting new account")
	rpc_id(1,"CreateAccountRequest", username, password)
	username = ""
	password= ""		

""""
func RequestLogin():
	print("Connecting to gateway to request login")
	rpc_id(1,"LoginRequest", username, password)
	username = ""
	password= ""
	
remote func ReturnLoginRequest(results, token):
	print("Results received")
	if results == true:
	   var login_canvas1 = get_node("/root/LoginScreenCanvasLayer")
	   if has_node("/root/LoginScreenCanvasLayer"):
		
		   print("Server")
	   if has_node("/root/LoginScreenCanvasLayer"):
		   Data.Data_file["Player_name"]={"Name":login_canvas1.username_input.text}
		   Data.Data_file["Player_password"]={"Password":login_canvas1.password_input.text}
		   Save.save_data["Player_name"]=Data.Data_file["Player_name"].Name
		   Save.save_game()
		   Data.SaveData()
		   
	else:
	   var login_canvas = get_node("/root/LoginScreenCanvasLayer")
	   if has_node("/root/LoginScreenCanvasLayer"):
		   login_canvas.response_label.text="Please provide correct username and password"
		   get_node("../GUI/LoginScreenCanvasLayer").login_button.disabled=false
		   get_node("../GUI/LoginScreenCanvasLayer").create_button.disabled=false
	network.disconnect("connection_failed", self, "_OnConnectionFailed")
	network.disconnect("connection_succeeded", self, "_OnConnectionSucceeded")		

	   
"""	   

		
remote func ReturnCreateAccountRequest(results,message):
	print("Results received")
	if results ==true:
		var login_canvas1 = get_node("/root/LoginScreenCanvasLayer")
		if has_node("/root/LoginScreenCanvasLayer"):
		  login_canvas1.accountCreated()
		  SaveUsername.p_username=login_canvas1.register_username.get_text()
		  SavePassword.p_password=login_canvas1.register_password.get_text()
		Server._readyNow()
		
		
	else:
		if message ==1:
			var login_canvas = get_node("/root/LoginScreenCanvasLayer")
			if has_node("/root/LoginScreenCanvasLayer"):
			  login_canvas.response_label.text="Couldn't create account, please try again"
			  login_canvas.register_button.disabled = false
			  login_canvas.login_button.disabled = false
		if message ==2:
			var login_canvas = get_node("/root/LoginScreenCanvasLayer")
			if has_node("/root/LoginScreenCanvasLayer"):
			   login_canvas.response_label.text="The username already exists, please use a different one"	
			   login_canvas.register_button.disabled = false
			   login_canvas.login_button.disabled = false
	network.disconnect("connection_failed", self, "_OnConnectionFailed")
	network.disconnect("connection_succeeded", self, "_OnConnectionSucceeded")		


