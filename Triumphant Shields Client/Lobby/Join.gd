extends Control



onready var player_name = $ColorRect/usernameLineEdit
onready var waiting_room = $WaitingRoom
onready var ready_btn = $WaitingRoom/ColorRect/ReadyButton
onready var selected_IP = $ColorRect/ipLineEdit
onready var selected_port = $ColorRect/portLineEdit



func _ready():
	player_name.text = SaveUsername.p_username #Get player's name from data file
	selected_IP.text = Server.DEFAULT_IP #Get connection IP
	selected_port.text = str(Server.DEFAULT_PORT) #Get connection port
	$ColorRect/shieldsLabel/shieldsValueLabel.text=(str(WinShields.shields)) #Display amount of shields earned
	

func _on_JoinButton_pressed():
	Server.selected_IP = selected_IP.text
	Server.selected_port = int(selected_port.text)
	Server._connect_to_server()
	show_waiting_room() #Display waiting room 
	$ChatterCanvas/Control.hide()
	yield(get_tree().create_timer(60),"timeout")
	Global.kick_reason= Global.KickReason.waiting_room #Kicks player out of waiting room if in there too long
	if Global.kick_reason==Global.KickReason.waiting_room:
		Global.kick()
	






func show_waiting_room():
	waiting_room.popup_centered()








func _on_ReadyButton_pressed():
	Server.load_game() #Loads game when more than one player joins
	ready_btn.disabled = true
	
	




