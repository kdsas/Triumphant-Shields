extends ColorRect



func _ready():
	InventoryCanvasLayer.hide_Invcanvas()



func _on_noButton_pressed():
	get_tree().disconnect("connected_to_server", self, "_connected_ok")
	get_tree().quit()
