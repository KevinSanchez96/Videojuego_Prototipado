extends State

var timer = 0.0

func enter():
	entity.velocity = Vector2.ZERO
	entity.get_node("Sprite2D").modulate = Color(1,0,0)
	timer = 0.2

func update(delta):
	timer -= delta
	
	if timer <= 0:
		entity.get_node("Sprite2D").modulate = Color(1,1,1)
		state_machine.change_state(state_machine.get_node("Idle"))
