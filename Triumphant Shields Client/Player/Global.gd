extends Node





enum QuestStatus { NOT_STARTED, STARTED, COMPLETED }
var quest_status = QuestStatus.NOT_STARTED
var completed = false
var enemy5_killed=false
var enemy10_killed=false
var blue_flowers=false
var yellow_flowers=false
var quest_accept=false
var Tuesday=false
var Wednesday=false
var Thursday=false
var Friday=false
var Saturday=false
var inv_count=false

var courage=0
var stealth=0
var wisdom=0
var add_courage=0
var add_stealth=0
var add_wisdom=0
var xp_Accept=false

var max_battle_health=50
var battle_health=max_battle_health

enum BanReason { not_banned, hate_speech}
var ban_reason = BanReason.not_banned

enum KickReason { not_kicked, waiting_room }
var kick_reason = KickReason.not_kicked

var in_Menu=false

var playBullet=""

var player_died=false

var manaPoints=100




func ban():
	
	Server.ban(Dictionary(Server.players[Server.local_player_id]), "reason")
	var world = get_node("/root/World")
	if has_node("/root/World"):
		world.queue_free()
		InventoryCanvasLayer.hide_Invcanvas()
	get_tree().change_scene("res://GUI/BanGUI.tscn")
	yield(get_tree().create_timer(4),"timeout")
	get_tree().quit()
	
func kick():	
	Server.kicked(Dictionary(Server.players[Server.local_player_id]), "reason")
	get_tree().change_scene("res://GUI/KickGUI.tscn")	
	yield(get_tree().create_timer(4),"timeout")
	get_tree().quit()
	



var lives = 100


func _readyIt():
		Global.LoadPlayerStats()
	
	
  
	
func LoadPlayerStats():
	add_courage+=1
	add_stealth+=2
	add_wisdom+=3
	courage= add_courage+1
	stealth= add_stealth+1
	wisdom= add_wisdom+1
	

