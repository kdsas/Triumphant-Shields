extends Control




onready var message = $Message
onready var typed_message = $TypedMessage
onready var chat_box = $CanvasLayer/ChatBox
var max_messages = 8





func message(player_name, data):
	var display_message = Label.new()
	chat_box.add_child(display_message)
	display_message.text = "%s : %s" % [player_name, data]
	


func _process(delta):
	if chat_box.get_child_count() > max_messages:
		chat_box.get_child(0).queue_free()


	











func _on_closeChatButton_toggled(button_pressed):
	if button_pressed:
		hide()
	else:
		show()	
