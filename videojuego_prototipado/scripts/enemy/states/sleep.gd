extends State

func update(delta):
	var enemy = get_parent().get_parent() # necesito referencia del enemy para poder hacer el siguiente if
	
	#if enemy.is_on_screen():
		#get_parent().change_state(get_parent().get_node("Chase"))
	
