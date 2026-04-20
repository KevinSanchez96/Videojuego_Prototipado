extends State

#aca se utiliza el Vecto2.ZERO para detener el movimiento tanto en X como en Y
#distinto seria de un plataformero ya que unicamente deberias detener el movimiento en X
func enter():
	owner.velocity = Vector2.ZERO
	
func update(delta):
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	var parent = get_parent()
	
	if direction != Vector2.ZERO:
		parent.change_state(parent.get_node("Move"))
