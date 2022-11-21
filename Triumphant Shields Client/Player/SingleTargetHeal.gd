extends Node2D

var heal_amount

func _ready():
	heal_amount=20
	Heal()
	
	
func Heal():
	get_node("AnimationPlayer").play("heal")
	get_parent().OnHeal(heal_amount)
	yield(get_tree().create_timer(0.6),"timeout")
	queue_free()	
