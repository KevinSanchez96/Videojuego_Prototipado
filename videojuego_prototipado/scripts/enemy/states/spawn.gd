extends State

func enter():
	entity.get_node("CollisionShape2D").set_deferred("disabled",false)
	state_machine.change_state(state_machine.get_node("Chase"))
	$"../../Animacion".visible = true
	$"../../Animacion".play("walk")
	
	###animacion
