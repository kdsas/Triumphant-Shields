extends KinematicBody2D

const MAXSPEED = 80
const ACCELERATION = 300
var motion = Vector2.ZERO
var possible_players
var target_player
var floating_text= preload("res://GUI/FloatingText.tscn")
var state ="Rest"
var player_in_range
var player_in_sight
var player_seen
var destination 
onready var players = get_tree().get_root().find_node("Players", true, false)
onready var world = get_tree().root.get_node("World")
var map_navigation
var blood = preload("res://Player/Blood.tscn")
var can_fire =true
onready var BULLET = preload("res://Player/PlayerBullet.tscn")
var speed =120
var fire_direction
var player_position
var enemy_kill_count=[]

func _ready():
	possible_players = players.get_children() #Count players
	target_player = possible_players[0] #Number of players for enemies to follow
	map_navigation=world.map #Enemies follow the map path
	



func _process(delta):
	match state:
	   "Rest":
		   print("ZZZZZzzz")
	   "Attack":
		   if can_fire==true:
			   Attack()
			   print("pew peww")
		   else:
			   pass
	   "Return":
		   pass
	   "Search":
		   Search(delta)
		
		
func Search(delta):
	var path_to_destination=map_navigation.get_simple_path(get_global_position(),destination)
	var starting_point=get_global_position()
	var move_distance=speed*delta	
	for point in range(path_to_destination.size()):
		var distance_to_next_point=starting_point.distance_to(path_to_destination[0])
		if move_distance <= distance_to_next_point: #Keeps moving enemy along path points
			var move_rotation=get_angle_to(starting_point.linear_interpolate(path_to_destination[0],move_distance/distance_to_next_point))
			var motion = Vector2(speed,0).rotated(move_rotation)
			move_and_slide(motion)
			break
		move_distance-=distance_to_next_point
		starting_point=path_to_destination[0]
		path_to_destination.remove(0)
		if path_to_destination.size()==0:
			player_seen=false
			state="Rest"
	

	
	
func _physics_process(delta): #Moves enemy
	var player_direction = (target_player.position - global_position).normalized()
	motion = motion.move_toward(player_direction * MAXSPEED, ACCELERATION * delta)
	motion = move_and_slide(motion)
	$AnimationTree.set("parameters/Side/blend_position",motion)
	SightCheck(target_player)


func _on_PlayerDetection_body_entered(body):
	if body.is_in_group('Player'):
		target_player = body
		player_in_range=true
		player_in_sight=true
		player_seen=true
		player_position=body.get_global_position()
		destination=map_navigation.get_closest_point(player_position)
		state="Attack"
		print("pew peww")
		Attack()
		

func _on_HurtBox_area_entered(area):
	var bullet =BULLET.instance()
	if area.is_in_group("Bullet") and bullet.p=="play":
		$CanvasLayer/ProgressBar._decrease_damage()
		$AudioStreamPlayer2D.play()
		var text = floating_text.instance()
		text.amount=20
		text.type="Damage"
		add_child(text)
		var blood_instance=blood.instance()
		add_child(blood_instance)
		blood_instance.global_position=global_position
		blood_instance.rotation=global_position.angle_to(global_position)
		if $CanvasLayer/ProgressBar.value <=0:
			  enemy_kill_count.append("kill")
			  queue_free()
			  rpc_id(1, "destroy_enemy")
			  if Global.quest_accept==true and enemy_kill_count.count("kill")==3 and Global.Tuesday==true:
					   var text1 = floating_text.instance()
					   text1.completionAlert="3 NPCs killed"
					   text1.type="Completion"
					   add_child(text1)
			  if Global.quest_accept==true and enemy_kill_count.count("kill")==5 and Global.Wednesday==true:
					   var text1 = floating_text.instance()
					   text1.completionAlert="5 NPCs killed"
					   text1.type="Completion"
					   add_child(text1)
			  if Global.quest_accept==true and enemy_kill_count.count("kill")>=5 and Global.Tuesday==true:
				  Global.enemy5_killed=true
				  Global.completed=true
				  Global.quest_status = Global.QuestStatus.COMPLETED
			  if Global.quest_accept==true and enemy_kill_count.count("kill")>=10 and Global.Wednesday==true:
				  Global.enemy10_killed=true
				  Global.completed=true	 
				  Global.quest_status = Global.QuestStatus.COMPLETED
		
	else:
		 if area.is_in_group("Glaive"):
		   $CanvasLayer/ProgressBar._decrease_damage_glaive()
		   $AudioStreamPlayer2D.play()
		   var text = floating_text.instance()
		   text.amount=40
		   text.type="Damage"
		   add_child(text)
		   var blood_instance=blood.instance()
		   add_child(blood_instance)
		   blood_instance.global_position=global_position
		   blood_instance.rotation=global_position.angle_to(global_position)
		   if $CanvasLayer/ProgressBar.value <=0:
			   enemy_kill_count.append("kill")
			   queue_free()
			   rpc_id(1, "destroy_enemy")
			   if Global.quest_accept==true and enemy_kill_count.count("kill")==3 and Global.Tuesday==true:
					   var text1 = floating_text.instance()
					   text1.completionAlert="3 NPCs killed"
					   text1.type="Completion"
					   add_child(text1)
			   if Global.quest_accept==true and enemy_kill_count.count("kill")==5 and Global.Wednesday==true:
					   var text1 = floating_text.instance()
					   text1.completionAlert="5 NPCs killed"
					   text1.type="Completion"
					   add_child(text1)
			   if Global.quest_accept==true and enemy_kill_count.count("kill")>=5 and Global.Tuesday==true:
				   Global.enemy5_killed=true
				   Global.completed=true
				   Global.quest_status = Global.QuestStatus.COMPLETED
				   
			   if Global.quest_accept==true and enemy_kill_count.count("kill")>=10 and Global.Wednesday==true:
				   Global.enemy10_killed=true
				   Global.completed=true	 
				   Global.quest_status = Global.QuestStatus.COMPLETED
				 
	
	if area.is_in_group("Helios"):
		$CanvasLayer/ProgressBar._decrease_damage_helios()
		var text = floating_text.instance()
		text.amount=60
		text.type="Critical"
		add_child(text)
		var blood_instance=blood.instance()
		add_child(blood_instance)
		blood_instance.global_position=global_position
		blood_instance.rotation=global_position.angle_to(global_position)
		if $CanvasLayer/ProgressBar.value <=0:
			enemy_kill_count.append("kill")
			queue_free()
			rpc_id(1, "destroy_enemy")
			if Global.quest_accept==true and enemy_kill_count.count("kill")==3 and Global.Tuesday==true:
					   var text1 = floating_text.instance()
					   text1.completionAlert="3 NPCs killed"
					   text1.type="Completion"
					   add_child(text1)
			if Global.quest_accept==true and enemy_kill_count.count("kill")==5 and Global.Wednesday==true:
					   var text1 = floating_text.instance()
					   text1.completionAlert="5 NPCs killed"
					   text1.type="Completion"
					   add_child(text1)
			if Global.quest_accept==true and enemy_kill_count.count("kill")>=5 and Global.Tuesday==true:
				Global.enemy5_killed=true
				Global.completed=true
				Global.quest_status = Global.QuestStatus.COMPLETED
			if Global.quest_accept==true and enemy_kill_count.count("kill")>=10 and Global.Wednesday==true:
				  Global.enemy10_killed=true
				  Global.completed=true
				  Global.quest_status = Global.QuestStatus.COMPLETED	
						
	else:
		if area.is_in_group("Sword"):
		  $CanvasLayer/ProgressBar._decrease_damage_sword()
		  var text = floating_text.instance()
		  text.amount=10
		  text.type="Damage"
		  add_child(text)
		  var blood_instance=blood.instance()
		  add_child(blood_instance)
		  blood_instance.global_position=global_position
		  blood_instance.rotation=global_position.angle_to(global_position)
		if $CanvasLayer/ProgressBar.value <=0:
			 enemy_kill_count.append("kill")
			 queue_free()
			 rpc_id(1, "destroy_enemy")
			 if Global.quest_accept==true and enemy_kill_count.count("kill")==3 and Global.Tuesday==true:
					   var text1 = floating_text.instance()
					   text1.completionAlert="3 NPCs killed"
					   text1.type="Completion"
					   add_child(text1)
			 if Global.quest_accept==true and enemy_kill_count.count("kill")==5 and Global.Wednesday==true:
					   var text1 = floating_text.instance()
					   text1.completionAlert="5 NPCs killed"
					   text1.type="Completion"
					   add_child(text1)
			 if Global.quest_accept==true and enemy_kill_count.count("kill")>=5 and Global.Tuesday==true:
				 Global.enemy5_killed=true
				 Global.completed=true
				 Global.quest_status = Global.QuestStatus.COMPLETED
			 if Global.quest_accept==true and enemy_kill_count.count("kill")>=10 and Global.Wednesday==true:
				 Global.enemy10_killed=true
				 Global.completed=true
				 Global.quest_status = Global.QuestStatus.COMPLETED	 
		

func OnHit(damage):
	$CanvasLayer/ProgressBar.value-=damage
	var text = floating_text.instance()
	text.amount=damage
	text.type="Critical"
	add_child(text)
	if $CanvasLayer/ProgressBar.value <=0:
		queue_free()
		rpc_id(1, "destroy_enemy")	

func _on_HitBox_body_entered(body):
	if body.is_in_group("Player"):
		body.damage()
		if players.get_children().size() > 1:
			rpc_id(1, "remove_player", body.name)
			players.remove_child(body)
		

func Attack():
	can_fire =false
	speed=1
	fire_direction=(get_angle_to(player_position)/3.14)*180
	var bullet =BULLET.instance()
	bullet.position=get_global_position()
	get_parent().add_child(bullet)
	yield(get_tree().create_timer(0.1),"timeout")
	can_fire=true
	speed=120
	


func _on_PlayerDetection_body_exited(body):
	if body.is_in_group('Player'):
		target_player = body
		player_in_range=false
		if player_seen ==true:
			state="Search"
		
		
func SightCheck(body):
	if player_in_range ==true:
	   if body.is_in_group('Player'):
		   player_in_sight=true
		   player_seen=true
		   player_position=body.get_global_position()
		   destination=map_navigation.get_closest_point(player_position)
		   state="Attack"
	   else:
		   player_in_sight=false
		   if player_seen==true:
			   state="Search"
		   else:	
			   state="Rest"

