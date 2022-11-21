extends Control


func _ready():
	InventoryCanvasLayer.hide_Invcanvas()

func _on_backButton_pressed():
	get_tree().change_scene("res://GUI/TitleScreen.tscn")
