extends State

func enter():
	entity.velocity = Vector2.ZERO
	entity.queue_free()
