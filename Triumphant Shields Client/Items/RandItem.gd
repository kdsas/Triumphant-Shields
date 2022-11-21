class_name RandItem extends Node

var cherries_icon: Icon=load("res://Items/RandomItems/CherriesRand.tres")
var flowerOne_icon: Icon=load("res://Items/RandomItems/Flower1Rand.tres")
var flowerTwo_icon: Icon=load("res://Items/RandomItems/Flower2Rand.tres")
var lootOne_icon: Icon=load("res://Items/RandomItems/Loot1Rand.tres")
var lootTwo_icon: Icon=load("res://Items/RandomItems/Loot2Rand.tres")

var cherries_count =0
var flower1_count =0
var flower2_count =0
var loot1_count =0
var loot2_count =0



func _ready():
	$Control/cherriesLabel.set_text(str(cherries_count))
	$Control/flower1Label.set_text(str(flower1_count))
	$Control/flower2Label.set_text(str(flower2_count))
	$Control/loot1Label.set_text(str(loot1_count))
	$Control/loot2Label.set_text(str(loot2_count))

func hide_Invcanvas():
	$Control/GridContainer.hide()
	$Control/cherriesLabel.hide()
	$Control/flower1Label.hide()
	$Control/flower2Label.hide()
	$Control/loot1Label.hide()
	$Control/loot2Label.hide()
	
	
func show_Invcanvas():
	$Control/GridContainer.show()
	$Control/cherriesLabel.show()
	$Control/flower1Label.show()
	$Control/flower2Label.show()
	$Control/loot1Label.show()
	$Control/loot2Label.show()	
	
func generate_cherries_icon()-> void:
	$Control/GridContainer/Slot1/Sprite.texture=cherries_icon.sprite
				
func generate_flowerOne_icon()-> void:
	$Control/GridContainer/Slot2/Sprite.texture=flowerOne_icon.sprite

func generate_flowerTwo_icon()-> void:
	$Control/GridContainer/Slot3/Sprite.texture=flowerTwo_icon.sprite
	
func generate_lootOne_icon()-> void:
	$Control/GridContainer/Slot4/Sprite.texture=lootOne_icon.sprite
	
func generate_lootTwo_icon()-> void:
	$Control/GridContainer/Slot5/Sprite.texture=lootTwo_icon.sprite					
	
func increase_cherries():
	cherries_count+=1
	$Control/cherriesLabel.set_text(str(cherries_count))

func increase_flower1():
	flower1_count+=1
	$Control/flower1Label.set_text(str(flower1_count))
	
func increase_flower2():
	flower2_count+=1
	$Control/flower2Label.set_text(str(flower2_count))

func increase_loot1():
	loot1_count+=1
	$Control/loot1Label.set_text(str(loot1_count))

func increase_loot2():
	loot2_count+=1
	$Control/loot2Label.set_text(str(loot2_count))	
	
						
