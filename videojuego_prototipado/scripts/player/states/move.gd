extends State

func update(delta):
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	var parent = get_parent() # get_parent() funcion que trae al nodo padre osea "State_Machine" para acceder y hacer el cambio de estado
	
	owner.velocity = direction * owner.speed
	owner.move_and_slide()
	
	if direction == Vector2.ZERO:
		parent.change_state(get_node("Idle"))
	
