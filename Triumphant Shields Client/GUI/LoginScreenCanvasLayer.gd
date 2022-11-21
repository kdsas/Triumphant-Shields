extends CanvasLayer


onready var username_input = $Control/NinePatchRect/usernameLineEdit
onready var password_input = $Control/NinePatchRect/passwordLineEdit
onready var login_button = $Control/NinePatchRect/loginButton
onready var forgot_button = $Control/NinePatchRect/forgotButton
onready var create_button = $Control/NinePatchRect/createButton
onready var register_username = $Control/NinePatchRect/registerUsernameLineEdit
onready var register_password = $Control/NinePatchRect/registerPasswordLineEdit	
onready var register_confirm_password = $Control/NinePatchRect/registerConfirmPasswordLineEdit
onready var register_button = $Control/NinePatchRect/registerButton
onready var register_label = $Control/NinePatchRect/RegisterLabel
onready var register_secret = $Control/NinePatchRect/registerSecretQuestionLineEdit
onready var question_label = $Control/NinePatchRect/QuestionLabel
onready var response_label = $Control/NinePatchRect/responseLabel





func _ready():
		  register_username.hide()
		  register_password.hide()
		  register_confirm_password.hide()	
		  register_button.hide()
		  register_label.hide()
		  register_secret.hide()
		  question_label.hide()
		  InventoryCanvasLayer.hide_Invcanvas()
		

func _on_loginButton_pressed():
	if username_input.get_text()== "" or password_input.get_text()=="":
	   response_label.text= "Please provide valid username and password"
	
	else:
		 login_button.disabled=true
		 create_button.disabled=true
		 if username_input.get_text()== SaveUsername.p_username and password_input.get_text()== SavePassword.p_password:
			   accountLogin()
		 else:
			  response_label.text="wrong information"
		 
		
		 




func _on_registerButton_pressed():
   if register_username.get_text()== "" or register_password.get_text()=="":
	   response_label.text="Please provide valid username and password"
   elif register_confirm_password.get_text()== "":
	   response_label.text="Please confirm your password"
   elif register_secret.get_text()== "":
	   response_label.text="Please answer secret question"	
   elif register_password.get_text() != register_confirm_password.get_text():
	   response_label.text="Passwords don't match"	
   elif register_password.get_text().length() <=7:
	   response_label.text="Password must contain at least 8 characters"		
	  else: 
		  register_button.disabled = true
		  login_button.disabled = true
		  create_button.disabled=true
		  SaveSecret.p_secret=register_secret.get_text()
		  var username = register_username.get_text()
		  var password = register_password.get_text()
		  Gateway.ConnectToLoginServer(username,password, true)
		  register_secret.text=""
		
			





func _on_createButton_pressed():
	register_username.show()
	register_password.show()
	register_confirm_password.show()	
	register_button.show()
	register_label.show()
	register_secret.show()
	question_label.show()

func _on_forgotButton_pressed():
	get_tree().change_scene("res://GUI/ForgotPasswordCanvasLayer.tscn")


func _on_reloadButton_pressed():
	get_tree().reload_current_scene()


func _on_backButton_pressed():
	get_tree().change_scene("res://GUI/TitleScreen.tscn")


func onlineScene():
	get_tree().change_scene("res://Lobby/Join.tscn")
	Server._connection()

func accountCreated():
	$Control/NinePatchRect/AccountCreated.show()
	yield(get_tree().create_timer(3),"timeout")		
	$Control/NinePatchRect/AccountCreated.hide()
	_on_reloadButton_pressed()
	

func accountLogin():
	$Control/NinePatchRect/AccountLogin.show()
	Save.save_data["Player_name"]=SaveUsername.p_username
	Save.save_game()




func _on_Button_pressed():
	onlineScene()
	






