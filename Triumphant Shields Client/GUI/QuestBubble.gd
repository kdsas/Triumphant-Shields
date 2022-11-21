extends Node2D
onready var text_node = $Anchor/RichTextLabel
onready var text_bg = $Anchor/ColorRect
const char_time = 0.02
const margin_offset = 8
var ofWeek=""
var preloadQuest:=["Collect 10 blue flowers","Collect 5 yellow flowers","Kill 5 NPC enemies","Kill 10 NPC enemies","In the in-game store, buy 10 cherries","In the in-game store, buy 10 flower1","In the in-game store, buy 10 loot1"]
var questFind
func _ready() -> void:
	visible = false
	var time = OS.get_datetime()
	var dayofweek = time["weekday"]
	if time["weekday"]==0:
		ofWeek="Sunday"
		questFind=(preloadQuest[0])
	if time["weekday"]==1:
		ofWeek="Monday"
		questFind=(preloadQuest[1])
	if time["weekday"]==2:
		ofWeek="Tuesday"
		questFind=(preloadQuest[2])
		Global.Tuesday=true
	if time["weekday"]==3:
		ofWeek="Wednesday"
		questFind=(preloadQuest[3])
		Global.Wednesday=true
	if time["weekday"]==4:
		ofWeek="Thursday"
		questFind=(preloadQuest[4])
		Global.Thursday=true
	if time["weekday"]==5:
		ofWeek="Friday"
		questFind=(preloadQuest[5])
		Global.Friday=true
	if time["weekday"]==6:
		ofWeek="Saturday"
		questFind=(preloadQuest[6])
		Global.Saturday=true
	var day="Day"+ ":"+ ofWeek
	set_text(questFind+" "+ day+" "+ "[color=red]Quest[/color]")	
	match Global.quest_status:
		Global.QuestStatus.NOT_STARTED:
			print("not started")			
			


	


func _process(delta):
	if Global.completed==true:
			visible = false
	Global.completed=false				

func set_text(text,wait_time=3):
	visible = true
	$Timer.wait_time = wait_time
	$Timer.stop()
	text_node.bbcode_text = text
	
	# Duration
	var duration = text_node.text.length() * char_time
	
	# Set the size of the speech bubble
	var text_size = text_node.get_font("normal_font").get_string_size(text_node.text)
	text_node.margin_right = text_size.x + margin_offset
	
	# Animation
	$Tween.remove_all()
	$Tween.interpolate_property(text_node, "percent_visible", 0, 1, duration)
	$Tween.interpolate_property(text_bg, "margin_right", 0, text_size.x + margin_offset, duration)
	$Tween.interpolate_property($Anchor, "position", Vector2.ZERO, Vector2(-text_size.x/2, 0), duration)
	$Tween.start()


func _on_Tween_tween_all_completed():
	$Timer.start()



	




func _on_quest_acceptButton_pressed():
	$Anchor/quest_acceptButton.hide()
	$Anchor/quest_declineButton2.hide()
	Global.quest_accept=true
	print("true")
	Global.quest_status = Global.QuestStatus.STARTED
	print("started")


func _on_quest_declineButton2_pressed():
	visible = false
