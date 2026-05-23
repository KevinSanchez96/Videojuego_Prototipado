extends State

func enter():
	entity.velocity = Vector2.ZERO
	print ("Player dead")
	entity.queue_free()
