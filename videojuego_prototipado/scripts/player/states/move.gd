extends State

func update(delta):
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")	
	entity.velocity = direction * entity.speed
	
	if direction == Vector2.ZERO:
		get_parent().change_state(get_parent().get_node("Idle"))
	
#dependiendo el input que se aprete , va a ser the last direction.
	#if Input.is_action_pressed("move_right"):
		#entity.last_direction = Vector2.RIGHT
	#elif Input.is_action_pressed("move_left"):
		#entity.last_direction = Vector2.LEFT
	
