extends Panel


onready var message = $txtMessage
onready var history = $txtChatHistory
onready var users : ItemList = $itlUsers


func _ready() -> void:
	#Connect to our custom signal in Network
	Network.connect("update_user_list",self,"update_user_list")
	get_tree().connect("network_peer_disconnected",self,"user_left")
	
	# if we're server just update list
	if(Network.host==true): 
		 update_user_list() 
	
#Called when a user enters the chat, clear the list and repopulate withupdated one
func update_user_list():
	users.clear()
	for i in Network.user_list:
		var data = Network.user_list[i]
		users.add_item(Network.user_list[i])
		if (Network.host==true):
			users.add_item("Block", null, true)
			

#Remove user by its ID and repopulate userlist
func user_left(ID):
	print(ID)
	Network.user_list.erase(str(ID)) # remove  from user_list
	update_user_list()


func _on_sendButton_pressed():
	if(message.text != "\n"):
			#Create the message and tell everyone else to add it to their history
			rpc_unreliable("send_chat",create_message())
			history.bbcode_text += create_message()
			message.text = ""
	else:
			message.text = ""


remote func send_chat(txt):
	history.bbcode_text += txt
	history.bbcode_text += ""

#We're using richtextlabel which allows us to format
func create_message() -> String:
	return "[b][color=" + Network.user_color +"]" + Network.user_name + ": "+"[/color][/b]" + message.text 


func _on_blockButton_pressed():
	Network.user_list[str(get_tree().get_network_unique_id())] = Network.user_name
	print("Kicking player with unique ID ", Network.user_name)
	Network.kick_player(Network.user_name)
	

func _on_itlUsers_item_selected(index):
	if users.is_selected(1):
		  OS.alert('You cannot block your own self!', 'Warning')
	if users.is_selected(2):
		  _on_blockButton_pressed()
	if users.is_selected(3):
		  _on_blockButton_pressed()
	if users.is_selected(4):
		  _on_blockButton_pressed()		



