extends CanvasLayer


onready var answer_input = $Control/NinePatchRect/answerLineEdit
onready var back_button = $Control/NinePatchRect/backButton
onready var hide_button = $Control/NinePatchRect/hideButton
onready var retrieve_label = $Control/NinePatchRect/retrieveLabel
onready var submit_button = $Control/NinePatchRect/submitButton

func _on_submitButton_pressed():
	if (answer_input.text==SaveSecret.p_secret):
		retrieve_label.text = "Username:"+ SaveUsername.p_username + "    "+"Password:"+ SavePassword.p_password
		answer_input.text= ""
		hide_button.show()
		retrieve_label.show()
	else:
		  retrieve_label.text= "Wrong Information Entered"
		  hide_button.show()
		  retrieve_label.show()


func _on_backButton_pressed():
	get_tree().change_scene("res://GUI/LoginScreenCanvasLayer.tscn")


func _on_hideButton_pressed():
	retrieve_label.hide()
	hide_button.hide()
