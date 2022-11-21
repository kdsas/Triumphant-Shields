extends Area2D

var damage=20
var damaged=40
var animation= "Helios_anim"
var damage_delay_time=0.3
var remove_delay_time=3

func _ready():
	AOEAttack()
	
	
func AOEAttack():
	get_node("AnimationPlayer").play(animation)
	yield(get_tree().create_timer(damage_delay_time),"timeout"	)
	var targets=get_overlapping_bodies()
	for target in targets:
		target.OnHit(damage)	
		yield(get_tree().create_timer(remove_delay_time),"timeout")
	self.queue_free()
	


func _on_RangedAOESkill_body_entered(body):
	if body.has_method('take_damage'):
		body.take_damage(damaged)
