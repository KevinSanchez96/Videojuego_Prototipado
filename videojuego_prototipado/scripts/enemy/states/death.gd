extends State

func enter():
	var enemy = get_parent().get_parent()
	
	enemy.velocity = Vector2.ZERO
	

	enemy.queue_free()
	
	
