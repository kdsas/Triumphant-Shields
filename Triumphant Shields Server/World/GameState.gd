extends Node2D


const PLAYER = preload("res://Player/Player.tscn")
const ENEMY= preload("res://Enemy/Enemy.tscn")

var enemy_count = 0

onready var players = $Players
onready var enemies = $Enemies

remote func spawn_players(id):
	var player = PLAYER.instance()
	player.name = str(id)
	players.add_child(player)
	rpc("spawn_player", id)
	
remote func spawn_enemies(pos):
	var enemy_instance = ENEMY.instance()
	var idx = randi() % pos
	enemy_instance.name = str(enemy_count)
	enemy_count += 1
	enemies.add_child(enemy_instance)
	rpc("spawn_enemy", idx, enemy_instance.name)
	
func delete_player(id):
	players.get_node(str(id)).queue_free()
