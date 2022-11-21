extends Node2D


const PLAYER = preload("res://Player/Player.tscn")
const ENEMY= preload("res://Enemy/Enemy.tscn")
var possible_destinations
var game_ended = false
var ready_players = 0
onready var player_spawn = $PlayerSpawn
onready var players = $Players
onready var destinations = $EnemySpawn
onready var enemies = $Enemies
onready var victory_status = $CanvasLayer/GUI/Label
onready var animation_player = $AnimationPlayer
onready var reset_timer = $ResetGame
onready var world = get_tree().get_root().get_node("World")
var health = 100
var map 


func subtractHealth():
		health-=5
		$PlayerCanvasLayer/MiscCanvasLayer/ProgressBar.value=health
	
func addHealth():
		$PlayerCanvasLayer/MiscCanvasLayer/ProgressBar.value=100
	

func _ready():
	possible_destinations = destinations.get_children()
	rpc_id(1, "spawn_players", Server.local_player_id)
	map=get_node("Navigation2D")
	InventoryCanvasLayer.show_Invcanvas()
	

	
		
	

func _process(delta):
	if ready_players == Server.players.size():
		if players.get_children().size() == 1:
			$PlayerCanvasLayer/MiscCanvasLayer/wonNotification.show()
		if players.get_children().size() == 1 and !game_ended:
			game_ended = true
			show_gui("You have won a shield")
			WinShields.shields+=1
			reset_timer.start()
	
	
	
remote func spawn_player(id):
	var player = PLAYER.instance()
	player.name = str(id)
	player.connect("player_ready", self, "on_player_ready")
	players.add_child(player)
	player.set_network_master(id)
	player.position = player_spawn.position
	
	

remote func spawn_enemy(idx, enemy_name):
	var new_destination = possible_destinations[idx]
	var enemy_instance = ENEMY.instance()
	enemy_instance.name = enemy_name
	enemies.add_child(enemy_instance)
	enemy_instance.position = new_destination.position
	

func _on_EnemySpawnTimer_timeout():
	rpc_id(1, "spawn_enemies", possible_destinations.size())
	
func show_gui(status):
	animation_player.play("gui")
	victory_status.text = status
	
	


func _on_ResetGame_timeout():
	Server.end_game()
	
func delete_player(id):
	players.get_node(str(id)).queue_free()
	InventoryCanvasLayer.queue_free()

func on_player_ready():
	ready_players += 1

	





	


		



