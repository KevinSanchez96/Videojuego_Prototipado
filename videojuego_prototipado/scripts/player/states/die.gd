extends State

func enter():
	entity.velocity = Vector2.ZERO
	print ("Player dead")
	entity.queue_free()
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
