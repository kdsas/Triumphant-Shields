extends Node2D


export(Resource) var item5=preload("res://Items/Loot2.tres")






var time=0

func _ready():
	$Sprite.texture=item5.texture
	name=item5.name
	randomize()
	
	
	
	
func _physics_process(delta):
	time+=delta
	$Sprite.position.y=sin(time)*2	
	$Sprite.rotation=cos(time*2)/8


func _on_Area2D_body_entered(body):
	if body.is_in_group('Player'):
		body.inventory.append(item5)
		if item5.name=="Cherries" and body.inventory.count(item5.name=="Cherries")<=0:
			InventoryCanvasLayer.generate_cherries_icon()
			InventoryCanvasLayer.increase_cherries()
		if item5.name=="Cherries" and body.inventory.count(item5.name=="Cherries")>0:
			InventoryCanvasLayer.increase_cherries()
		else:
			if item5.name=="Flower1" and body.inventory.count(item5.name=="Flower1")<=0:
			 InventoryCanvasLayer.generate_flowerOne_icon()
			 InventoryCanvasLayer.increase_flower1()
		if item5.name=="Flower1" and body.inventory.count(item5.name=="Flower1")>0:
			InventoryCanvasLayer.increase_flower1()
		else:
			if item5.name=="Flower2" and body.inventory.count(item5.name=="Flower2")<=0:
			 InventoryCanvasLayer.generate_flowerTwo_icon()
			 InventoryCanvasLayer.increase_flower2()
		if item5.name=="Flower2" and body.inventory.count(item5.name=="Flower2")>0:
			InventoryCanvasLayer.increase_flower2()
		else:
			if item5.name=="Loot1" and body.inventory.count(item5.name=="Loot1")<=0:
			 InventoryCanvasLayer.generate_lootOne_icon()
			 InventoryCanvasLayer.increase_loot1()
		if item5.name=="Loot1" and body.inventory.count(item5.name=="Loot1")>0:
			InventoryCanvasLayer.increase_loot1()
		else:
			if item5.name=="Loot2" and body.inventory.count(item5.name=="Loot2")<=0:
			 InventoryCanvasLayer.generate_lootTwo_icon()
			 InventoryCanvasLayer.increase_loot2()
		if item5.name=="Loot2" and body.inventory.count(item5.name=="Loot2")>0:
			InventoryCanvasLayer.increase_loot2()						
		queue_free()
