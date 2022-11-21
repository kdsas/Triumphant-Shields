extends ProgressBar

func _ready():
	set_process(false)
	
	
func set_bar_value(value_to_set):
	value= value_to_set
	$Timer.start()
	

func _on_Timer_timeout():
	set_process(true)
	
	
func _process(delta):
	$ProgressBar2.value= lerp($ProgressBar2.value, value, 0.1)
	if($ProgressBar2.value- value <=0.5):
		$ProgressBar2.value= value
		set_process(false)


func _decrease_damage_sword():
	set_bar_value(value-10)	

func _decrease_damage():
	set_bar_value(value-20)
	
func _decrease_damage_glaive():
	set_bar_value(value-40)
	
func _decrease_damage_helios():
	set_bar_value(value-60)
	

