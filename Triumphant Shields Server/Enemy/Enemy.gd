extends Node2D

onready var players = get_tree().get_root().find_node("Players", true, false)

func _ready():
	randomize()
	

	
remote func destroy_enemy():
	queue_free()
	
remote func remove_player(player):
	players.remove_child(players.get_node(player))
