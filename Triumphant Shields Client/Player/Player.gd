extends KinematicBody2D

const MAXSPEED = 100
const ACCELERATION = 300
const FRICTION = 200
const MAX_SPEED = 200 
var motion = Vector2.ZERO
onready var player_label = $Label
onready var camera = $Camera2D
var can_fire = true
onready var collision = $CollisionPolygon2D
onready var fire_rate = $FireRate
const BULLET = preload("res://Player/PlayerBullet.tscn")
var GLAIVE = load("res://Player/PlayerGlaive.tscn")
var HELIOS = load("res://Player/HeliosSunBall.tscn")
onready var weapon =$Weapon
onready var bullet_loc = $BulletFireLoc
onready var mana_bar = $ManaBar
onready var world = get_tree().get_root().get_node("World")
var floating_text= preload("res://GUI/FloatingText.tscn")
var can_heal=true
var dead=false
var percentage_hp=100
var heal_count=0
signal player_ready
var inventory=[]
var blood = preload("res://Player/Blood.tscn")

var max_mana=100
var mana
signal mana_changed


func _process(delta):
	heal()
	HPUpdate()
	var mouse_pos := get_global_mouse_position()
	if position.distance_to(mouse_pos) < (MAX_SPEED * delta):
		move_and_collide(position.direction_to(get_global_mouse_position()))
	else:
		move_and_collide(position.direction_to(get_global_mouse_position()).normalized() * MAX_SPEED * delta)


		


func _ready():
	player_label.set_as_toplevel(true)
	set_player_name()
	emit_signal("player_ready")
	mana=max_mana
	emit_signal("mana_changed", mana*100/max_mana, true)
	mana_bar.max_value=max_mana
	Global.manaPoints=mana
	print("Mana Points: "+ str(Global.manaPoints))
	
sync func take_damage(amount):
		mana-=amount
		emit_signal("mana_changed", mana*100/max_mana, false)
		mana_bar.value=mana
		Global.manaPoints=mana
		print("Mana Points: "+ str(Global.manaPoints))
		if mana <=0:
			damage()
			
	
			
func set_player_name ():
	player_label.text = Server.players[int(name)]["Player_name"] #Display player's name

	


func _physics_process(delta): #Display player's movements and actons across network 
	if is_network_master():
		camera.current = true
		player_label.rect_position = Vector2(position.x - 40, position.y - 60)
		var input_vector = get_input_vector()
		apply_movement(input_vector, delta)
		apply_friction(input_vector, delta)
		motion = move_and_slide(motion)
		$AnimationTree.set("parameters/Side/blend_position",motion)
		fire()
		fire_glaive()
		fire_helios()
		swing_sword()
		rpc_unreliable_id(1, "update_player", global_transform)
			
	
	
func get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector.x=0
	if input_vector.x >0:
		$Sprite.flip_h=false
		weapon.rotation_degrees=0
	elif input_vector.x<0:
		$Sprite.flip_h=true
		weapon.rotation_degrees=180
	return input_vector.normalized()
	
	
func apply_movement(input_vector, delta):
	look_at(get_global_mouse_position())
	if input_vector != Vector2.ZERO:
		motion = motion.move_toward(input_vector * MAXSPEED, ACCELERATION * delta)

		
func apply_friction(input_vector, delta):
	if input_vector == Vector2.ZERO:
		motion = motion.move_toward(Vector2.ZERO, FRICTION * delta)		

remote func update_remote_player(transform):
	if not is_network_master():
		global_transform = transform
		player_label.rect_position = Vector2(position.x - 40, position.y - 60)



func swing_sword():
	if Input.is_action_pressed("sword_swing"):
		weapon.attack()
		$AudioStreamPlayer2DSword.play()

func fire():
	if Input.is_action_pressed("ui_select") and can_fire and LevelUp.bestscore >=100 :
		rpc_id(1, "player_bullet")
		can_fire = false
		fire_rate.start()
		Global.playBullet="yes"
	
		
		
sync func spawn_bullet():
	var bullet_instance = BULLET.instance()
	world.add_child(bullet_instance)
	bullet_instance.transform = bullet_loc.global_transform
	

sync func spawn_glaive():
	var glaive_instance = GLAIVE.instance()
	add_child(glaive_instance)
	glaive_instance.global_position=self.global_position
	var glaive_rotation=self.global_position.direction_to(global_position).angle()
	glaive_instance.rotation=glaive_rotation
	
sync func spawn_helios():
	var helios_instance = HELIOS.instance()
	add_child(helios_instance)
	helios_instance.global_position=self.global_position
	var helios_rotation=self.global_position.direction_to(global_position).angle()
	helios_instance.rotation=helios_rotation
	var skill = load("res://Player/RangedAOESkill.tscn")
	var skill_instance=skill.instance()
	add_child(skill_instance)
	skill_instance.global_position=self.global_position
	var skill_rotation=self.global_position.direction_to(global_position).angle()
	skill_instance.rotation=skill_rotation
	
	
func heal():
	if percentage_hp<=50 and can_heal==true:
		 can_heal=false
		 yield(get_tree().create_timer(0.25),"timeout")
		 if dead==true:
			 pass
		 else:	
		   var skill1 = load("res://Player/SingleTargetHeal.tscn")
		   var skill_instance1=skill1.instance()
		   add_child(skill_instance1)
		   yield(get_tree().create_timer(1),"timeout")
		   can_heal=true
		   heal_count+=1
		   if is_network_master():   
				   if heal_count>=3:
						  damage()
		
	
func HPUpdate():
	percentage_hp=int((float($Health.current)/$Health.max_amount)*100)
	if percentage_hp>=60:
		print("60+ hp")
	elif percentage_hp<=60 and percentage_hp >=25:
		print("hp way low")
	else:
		print("hp out")	
		
	


func _on_FireRate_timeout():
	can_fire = true
	

func fire_glaive():
	if Input.is_action_pressed("ui_accept") and can_fire and LevelUp.bestscore >=300 :
		rpc_id(1, "player_glaive")
		can_fire = false
		fire_rate.start()
	


func fire_helios():
	if Input.is_action_pressed("ui_cancel") and can_fire and LevelUp.bestscore >=500:
		rpc_id(1, "player_helios")
		can_fire = false
		fire_rate.start()
		

func damage():
	if is_network_master():
		world.show_gui("You Died, You Lose")
	rpc_id(1, "die")	
	
	

	

	

sync func player_died():
	set_physics_process(false)
	collision.disabled = true
	hide()
	dead=true
	Global.player_died=true
	player_label.hide()
	
	

	



	

func OnHeal(heal_amount):
	  $Health.current+=heal_amount
	  Global.lives=+8
	  world.addHealth()
	  var text = floating_text.instance()
	  text.amount=heal_amount
	  text.type="Heal"
	  add_child(text)
	  if $Health.current >=$Health.max_amount:
		  $Health.current =$Health.max_amount
	  HPUpdate()


func OnHit(damage):
	#if is_network_master():
	  $Health.current-damage
	  Global.lives=-8
	  if Global.lives<=0 and $Health.current<=0:	
	   damage()
	
func _on_HurtBox_area_entered(area):
 #if is_network_master():
	 if area.is_in_group("Bullet"):
	   $Health.current-=0.08
	   world.subtractHealth()
	   percentage_hp-=20
	   $AudioStreamPlayer2DDaggerandGlaive.play()
	   var text = floating_text.instance()
	   text.amount=0.08
	   text.type="Damage"
	   add_child(text)
	   var blood_instance=blood.instance()
	   add_child(blood_instance)
	   blood_instance.global_position=global_position
	   blood_instance.rotation=global_position.angle_to(global_position)
	   Global.lives=-1
	 if Global.lives<=0 and $Health.current<=0:	
	  
		 damage()
	 else:
	  if area.is_in_group("Glaive"):
		  $Health.current-=0.32
		  world.subtractHealth()
		  percentage_hp-=20
		  $AudioStreamPlayer2DDaggerandGlaive.play()
		  var text = floating_text.instance()
		  text.amount=0.32
		  text.type="Damage"
		  add_child(text)
		  var blood_instance=blood.instance()
		  add_child(blood_instance)
		  blood_instance.global_position=global_position
		  blood_instance.rotation=global_position.angle_to(global_position)
		  Global.lives=-4
	 if Global.lives<=0 and $Health.current<=0:	
	
		 damage()
	 if area.is_in_group("Helios"):
		  $Health.current-=0.64
		  world.subtractHealth()
		  percentage_hp-=20
		  var text = floating_text.instance()
		  text.amount=0.64
		  text.type="Critical"
		  add_child(text)
		  var blood_instance=blood.instance()
		  add_child(blood_instance)
		  blood_instance.global_position=global_position
		  blood_instance.rotation=global_position.angle_to(global_position)
		  Global.lives=-8
	 if Global.lives<=0 and $Health.current<=0:	
	 
		 damage()	
	 else:
		 if area.is_in_group("Sword"):
		  $Health.current-=0.04
		  world.subtractHealth()
		  percentage_hp-=20
		  var text = floating_text.instance()
		  text.amount=0.04
		  text.type="Damage"
		  add_child(text)
		  var blood_instance=blood.instance()
		  add_child(blood_instance)
		  blood_instance.global_position=global_position
		  blood_instance.rotation=global_position.angle_to(global_position)
		  Global.lives=-1
	 if Global.lives<=0 and $Health.current<=0:	
	
		 damage()



