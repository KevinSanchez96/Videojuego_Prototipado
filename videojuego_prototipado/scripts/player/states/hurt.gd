extends State

var timer = 0.2

func enter():
	entity.velocity = Vector2.ZERO

func update(delta):
	timer = 0.2
	timer -= delta
	if timer <= 0:
		state_machine.change_state(state_machine.get_node("Idle"))
