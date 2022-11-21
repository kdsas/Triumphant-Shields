extends Node2D

remote func update_player(transform):
	rpc_unreliable("update_remote_player", transform)
	
remote func player_bullet():
	rpc("spawn_bullet")
	
remote func player_glaive():
	rpc("spawn_glaive")

remote func player_helios():
	rpc("spawn_helios")
	
	
remote func die():
	rpc("player_died")



