extends CanvasLayer

onready var chat = get_node("ChatCanvasLayer/Chat")
onready var player_stats = $StatsCanvasLayer/PlayerStats
onready var world = get_tree().get_root().get_node("World")
 



func _ready():
	$MiscCanvasLayer/mpLabel.text="Mana Points: "+ str(Global.manaPoints)
	
	


func _process(delta):
	$MiscCanvasLayer/mpLabel.text="Mana Points: "+ str(Global.manaPoints)
	if Global.manaPoints <=0:
			$MiscCanvasLayer/mpLabel.text="Mana Points: "+ str(0)
	if Global.player_died==true:
		show_dead_notification()
	if Global.completed==true:
		  $XPNotificationCanvasLayer/XPNotifcation.show()
		  yield(get_tree().create_timer(4),"timeout")
		  $XPNotificationCanvasLayer/XPNotifcation.hide()
	Global.completed=false
	
	
func show_dead_notification():
	$MiscCanvasLayer/lostNotification.show()


func _on_btn_submit_pressed(): #Submits chat message and bans for hate speech
	if chat.typed_message.text == "chink":
		SaveBan.p_ban="banned"
		Global.ban_reason= Global.BanReason.hate_speech
		Global.ban()
	if chat.typed_message.text == "gook":
		SaveBan.p_ban="banned"
		Global.ban_reason= Global.BanReason.hate_speech
		Global.ban()
	if chat.typed_message.text == "kike":
		SaveBan.p_ban="banned"
		Global.ban_reason= Global.BanReason.hate_speech
		Global.ban()
	if chat.typed_message.text == "kyke":
		SaveBan.p_ban="banned"
		Global.ban_reason= Global.BanReason.hate_speech
		Global.ban()	
	if chat.typed_message.text == "nigger":
		SaveBan.p_ban="banned"
		Global.ban_reason= Global.BanReason.hate_speech
		Global.ban()
	if chat.typed_message.text == "spic":
		SaveBan.p_ban="banned"
		Global.ban_reason= Global.BanReason.hate_speech
		Global.ban()							
	if chat.typed_message.text != "":
		Server.add_to_chat(chat.typed_message.text)
		chat.typed_message.text = ''
		

	



func combatProgress(): #Displays XP success to players through chat
	 if LevelUp.bestscore==50:
	   var text="about to start shooting daggers"
	   Server.add_to_chat('[/User]'+ "  " + text + "  " +'/]')
	   

	 if LevelUp.bestscore==150:
	   var text="about to start flinging glaives"
	   Server.add_to_chat('[/User]'+ "  " + text + "  " +'/]')

	 if LevelUp.bestscore==250:
	   var text="about to start firing Helios Sun Balls"
	   Server.add_to_chat('[/User]'+ "  " + text + "  " +'/]')
   




   

	








func _on_Button2_pressed():
	player_stats._ready() #Gets player stats





	
	





func _on_Button_pressed(): #Accepts XP
	_on_Button2_pressed()
	combatProgress()
	Global.xp_Accept=true

	
	
