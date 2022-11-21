extends Control

var is_paused=false setget set_is_paused


func set_is_paused(value):
	is_paused=value
	get_tree().paused=is_paused
	visible=is_paused
	
	
func readInstructions():
	self.is_paused=!is_paused





	


func _ready():
	if Global.in_Menu:
		$Panel/Button2.show()
		$Panel/Button.hide()
	else:
		$Panel/Button2.hide()
		$Panel/Button.show()
		



func _on_Button_pressed():
	self.is_paused=false


func _on_howtoPlayButton_pressed():
	self.is_paused=true


func _on_quitButton_pressed():
	get_tree().disconnect("connected_to_server", self, "_connected_ok")
	get_tree().quit()


func _on_Button2_pressed():
	get_tree().change_scene("res://GUI/TitleScreen.tscn")
