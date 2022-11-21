extends Control


func _ready():
	InventoryCanvasLayer.hide_Invcanvas()
	
	$btn_Video.connect("pressed",self,"Video")
	$btn_Audio.connect("pressed",self,"Audio")
	$btn_Back.connect("pressed",self,"Back")
	$cntrl_Video/btn_Resolution.connect("item_selected",self,"Resolution")
	$cntrl_Video/btn_Fullscreen.connect("item_selected",self,"Fullscreen")
	$cntrl_Audio/btn_Master_Mute.connect("pressed",self,"Mute_Master")
	$cntrl_Audio/sldr_Master.connect("value_changed",self,"Master_Volume")
	$cntrl_Audio/btn_Music_Mute.connect("pressed",self,"Mute_Music")
	$cntrl_Audio/sldr_Music.connect("value_changed",self,"Music_Volume")
	$cntrl_Audio/btn_Effects_Mute.connect("pressed",self,"Mute_Effects")
	$cntrl_Audio/sldr_Effects.connect("value_changed",self,"Effects_Volume")
	
	
	$cntrl_Video/btn_Resolution.add_item("800 X 600",0)
	$cntrl_Video/btn_Resolution.add_item("1920 X 1080",1)
	
	if(Options.res_width == 800 and Options.res_height == 600):
		$cntrl_Video/btn_Resolution.select(0)
	elif(Options.res_width == 1920 and Options.res_height == 1080):
		$cntrl_Video/btn_Resolution.select(1)	
		
	$cntrl_Video/btn_Fullscreen.add_item("Fullscreen",0)
	$cntrl_Video/btn_Fullscreen.add_item("Windowed",1)	
	
	if(Options.fullscreen==true):
		$cntrl_Video/btn_Fullscreen.select(0)
	elif(Options.fullscreen==false):
		$cntrl_Video/btn_Resolution.select(1)	
		
		
	$cntrl_Audio/sldr_Master.set_value(Options.Master_Volume)
	$cntrl_Audio/sldr_Music.set_value(Options.Music_Volume)
	$cntrl_Audio/sldr_Effects.set_value(Options.Effects_Volume)

	
	
func Video():
	$cntrl_Video.show()
	$cntrl_Audio.hide()
	Options.resolution()
	
	

func Audio():
	$cntrl_Video.hide()
	$cntrl_Audio.show()

	
	
func Back():
	get_tree().change_scene("res://GUI/TitleScreen.tscn")	
	
func Resolution(item):
	match item:
		0:
			Options.res_width=800
			Options.res_height=600
			Options.resolution()
			Options.save_game()
			
		1:
			Options.res_width=1920
			Options.res_height=1080
			Options.resolution()	
			Options.save_game()
	
func Fullscreen(item):
	match item:
		0:
			Options.fullscreen=true
			Options.resolution()
			Options.save_game()
			
		1:
			Options.fullscreen=false
			Options.resolution()	
			Options.save_game()	


func Mute_Master():
	if(Options.Master_Mute==false):
		Options.Master_Mute=true
	elif	(Options.Master_Mute==true):
		Options.Master_Mute=false
	AudioServer.set_bus_mute(0, not AudioServer.is_bus_mute(0))
	Options.choose_music()
	Options.save_game()	
	pass
	

func Master_Volume(value):
	Options.Master_Volume=$cntrl_Audio/sldr_Master.get_value()
	Options.save_game()	
	pass
	
func Mute_Music():
	if(Options.Music_Mute==false):
		Options.Music_Mute=true
	elif	(Options.Music_Mute==true):
		Options.Music_Mute=false
	AudioServer.set_bus_mute(0, true)
	Options.choose_music()
	Options.save_game()		
	pass
	

func Music_Volume(value):
	Options.Music_Volume=$cntrl_Audio/sldr_Music.get_value()
	Options.save_game()
	pass
	
func Mute_Effects():
	if(Options.Effects_Mute==false):
		Options.Effects_Mute=true
	elif	(Options.Master_Mute==true):
		Options.Effects_Mute=false
	AudioServer.set_bus_mute(0, not AudioServer.is_bus_mute(0))
	Options.choose_music()
	Options.save_game()	
	pass	

func Effects_Volume(value):
	Options.Effects_Volume=$cntrl_Audio/sldr_Effects.get_value()
	Options.save_game()
	pass	
