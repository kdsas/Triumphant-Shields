extends Node2D


func _ready():
	InventoryCanvasLayer.hide_Invcanvas()

func _on_enterButton_pressed():
	get_tree().change_scene("res://GUI/LoginScreenCanvasLayer.tscn")


func _on_quitButton_pressed():
	get_tree().quit()


func _on_creditsButton_pressed():
	get_tree().change_scene("res://GUI/Credits.tscn")


func _on_settingsButton_pressed():
	get_tree().change_scene("res://GUI/Options.tscn")


func _on_instructionsButton_pressed():
	Global.in_Menu=true
	get_tree().change_scene("res://GUI/Instructions.tscn")
