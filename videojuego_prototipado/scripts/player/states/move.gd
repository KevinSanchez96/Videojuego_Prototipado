extends State

func update(delta):
	entity.moving = true
	if !entity.control_habilitado:
		entity.velocity = Vector2.ZERO
		return 

	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	entity.velocity = direction * entity.speed
	
	if direction == Vector2.ZERO:
		get_parent().change_state(get_parent().get_node("Idle"))
		entity.moving = false
	
	entity.actualizar_animacion()
	
