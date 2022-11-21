extends Control


onready var skill_progress = get_node("SkillsConnector/1to4/TextureProgress")
onready var dagger_button=get_node("SkillTree/Dagger2/2/TextureButton")
onready var glaive_button=get_node("SkillTree/Glaive3/3/TextureButton")
onready var helios_button=get_node("SkillTree/Helios4/4/TextureButton")


func _ready():
	LoadSkills()
	


func LoadSkills(): #Displays combat tools available to the player based on score
	if LevelUp.bestscore >=100:
	   skill_progress.value=35
	   dagger_button.disabled=false
	
	if LevelUp.bestscore >=300:
		   skill_progress.value=70
		   glaive_button.disabled=false
	
	if LevelUp.bestscore >=500:
	   skill_progress.value=100
	   helios_button.disabled=false	



	


func _on_showButton_toggled(button_pressed): #Shows/hides skill tree
	if button_pressed==true:
	   get_node("SkillsConnector").show()
	   get_node("SkillTree").show()
	else:
		get_node("SkillsConnector").hide()
		get_node("SkillTree").hide()
		
