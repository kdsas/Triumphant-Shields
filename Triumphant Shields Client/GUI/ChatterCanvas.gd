extends CanvasLayer

onready var joinbutton = $Control/joinButton
onready var hostbutton = $Control/hostButton
onready var status = $Control/statusLabel/statusText
onready var colors = $Control/colorLabel/optColors
onready var ip_address = $Control/txtIP


func _ready() -> void:
	compile_colors()
	get_tree().connect("connection_failed", self, "connected_fail")
	
#populate the option list with colors
func compile_colors():
	colors.add_item("red")
	colors.add_item("green")
	colors.add_item("yellow")
	colors.add_item("blue")
	colors.add_item("black")
	colors.add_item("purple")



func _on_optColors_item_selected(index: int) -> void:
	Network.user_color=colors.text


func _on_hostButton_pressed():
	Network.create_server()
	status.text = "Hosting"
	joinbutton.disabled = true
	hostbutton.disabled = true
	Network.user_name =SaveUsername.p_username
	Network.host=true
	#put our username and ID in the dictionary
	Network.user_list[str(get_tree().get_network_unique_id())] = Network.user_name
	
	


func _on_joinButton_pressed():
	#Create a  client that will connect to the server
	var client : NetworkedMultiplayerENet = NetworkedMultiplayerENet.new()
	client.create_client(ip_address.text,3035)
	get_tree().set_network_peer(client)
	
	#Disable buttons while we wait
	joinbutton.disabled = true
	hostbutton.disabled = true
	
	#Update status and username for chatroom
	status.text = "Joined" + ip_address.text
	Network.user_name = SaveUsername.p_username

func connected_fail():
	print("Failed to connect")
	status.text = "Couldn't connect try again, or host?"
	#Connection failed so allow user to try again
	joinbutton.disabled = false
	hostbutton.disabled = false


func _on_exitButton_pressed():
	get_tree().network_peer = null
	Network.user_list.clear()
	$Control.hide()
