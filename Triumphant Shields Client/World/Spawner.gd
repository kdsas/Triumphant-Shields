extends Node2D


onready var spawnTimer:=$SpawnTimer
var nextSpawnTime:=4.5
var rng:=RandomNumberGenerator.new()
var preloadInv:=[preload("res://Items/SpawnInv/CherriesItem.tscn"),
preload("res://Items/SpawnInv/Flower1Item.tscn"),
preload("res://Items/SpawnInv/Flower2Item.tscn"),
preload("res://Items/SpawnInv/Loot1Item.tscn"),
preload("res://Items/SpawnInv/Loot2Item.tscn")
]

func _ready():
	#randomize()
	rng.randomize()
	spawnTimer.start(nextSpawnTime)
	


func _on_SpawnTimer_timeout():
	var viewRect:=get_viewport_rect()
	var xPos:=rand_range(viewRect.position.x,viewRect.end.x)
	var invPreload=preloadInv[rng.randi_range(1,preloadInv.size())-1]
	var inv=invPreload.instance()
	inv.position=Vector2(xPos,position.y)
	add_child(inv)
	
	spawnTimer.start(nextSpawnTime)
