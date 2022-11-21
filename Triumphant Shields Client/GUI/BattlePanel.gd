extends Panel


var npc_strength=10

var cannons=3

var npc_panel_scene=preload("res://GUI/NPCPanel.tscn")


var main=load("res://GUI/Store.tscn")
var main1
func _ready():
	SetupBattle() #Establishes NPCs
	main1=main.instance()

	
func init(_main):   #Loads the store scene
	_main.add_child(self)
	main=_main
		
	
func SetupBattle():
	randomize()
	var num_npcs=rand_range(1,npc_strength)
	for i in range (1, num_npcs):
		$NPCContainer.add_child(npc_panel_scene.instance()) #Randomizes NPCs
		
		


func _on_attackButton_pressed(): #Removes NPCs each time button is pressed
	var npcs_killed=rand_range(1,cannons)
	$AudioStreamPlayer2D.play()
	if npcs_killed>=$NPCContainer.get_child_count(): #counts number of NPCs left
		npcs_killed=$NPCContainer.get_child_count()
	for i in range(0,npcs_killed):
		$NPCContainer.remove_child($NPCContainer.get_child(0))
	if $NPCContainer.get_child_count()==0:
		EndBattle()
	else:
		NPCAttack()	


func NPCAttack():
	var dmg=int(rand_range(0,npc_strength)) 
	Global.battle_health-=dmg
	if Global.battle_health <=0:
		Global.battle_health=0
		main1.UpdateNohealth()
		GameOver()	
	main1.Updatehealth()
	

func EndBattle():
	get_parent().remove_child(self)	
	
	
func GameOver():
	queue_free()
	
		
	



func _on_fleeButton_pressed():
	queue_free()
