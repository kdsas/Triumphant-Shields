extends Area2D

onready var anim = $AnimationPlayer
var damage =5




func attack():
	anim.play("swing")


func _on_Weapon_body_entered(body):
	if not body.is_in_group("Player"):
		print("body was entered")
		#queue_free()


func _on_Weapon_area_entered(area):
	if "HurtBox" in area.name:
		print("area was entered")
		#queue_free()


func _on_Weapon_body_entered1(body):
	if body.has_method('take_damage'):
		body.take_damage(damage)
		
