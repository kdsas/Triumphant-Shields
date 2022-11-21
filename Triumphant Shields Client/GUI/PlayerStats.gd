extends Label


onready var courage = get_node("ColorRect/courageLabel/value")
onready var stealth = get_node("ColorRect/stealthLabel/value")
onready var wisdom = get_node("ColorRect/wisdomLabel/value")
onready var level_label= get_node("ColorRect/levelLabel")
onready var best_label= get_node("ColorRect/bestscoreLabel")
onready var experience_bar = get_node("ExperienceBar/HBoxContainer/TextureProgress")
onready var experience_bar_label = get_node("ExperienceBar/HBoxContainer/TextureProgress/Label")


var score =0
var level_up

func initial():
	Global.courage=0
	Global.stealth=0
	Global.wisdom=0

func _ready():
	if Global.xp_Accept==false:
		initial()
	else:	
		Global._readyIt()
	courage.set_text(str(Global.courage))
	stealth.set_text(str(Global.stealth))
	wisdom.set_text(str(Global.wisdom))
	level_label.set_text(str(SetLevel.level))
	Data.Data_file["Player_xp_courage"]={"Courage":courage.text}
	Data.Data_file["Player_xp_stealth"]={"Stealth":stealth.text}
	Data.Data_file["Player_xp_wisdom"]={"Wisdom":wisdom.text}
	score = int(courage.text)+int(stealth.text)+int(wisdom.text)
	set_score (score)
	SetExperienceBar()
	best_label.set_text(str(LevelUp.bestscore))
	Data.SaveData()
	

	
  
func set_score (new_value):
	score= new_value
	if score > LevelUp.bestscore:
		level_up=true
		LevelUp.bestscore = score
		if level_up:
			SetLevel.level+=1
		

	


func SetExperienceBar():
	get_node("ExperienceBar/HBoxContainer/TextureProgress")
	experience_bar.max_value=LevelUp.bestscore
	experience_bar.value = score
	experience_bar_label.set_text(str(score) + " / " + str(LevelUp.bestscore))	
	



