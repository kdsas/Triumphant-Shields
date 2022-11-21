extends Area2D

export var speed = 1300
var damage =15


func _physics_process(delta):
	position += transform.x * speed * delta




func _on_PlayerGlaive_area_entered(area):
	if "HurtBox" in area.name:
		print("area was entered")
		queue_free()





func _on_PlayerGlaive_body_entered(body):
	if not body.is_in_group("Player"):
		print("body was entered")
		queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_PlayerGlaive_body_entered1(body):
	if body.has_method('take_damage'):
		body.take_damage(damage)
