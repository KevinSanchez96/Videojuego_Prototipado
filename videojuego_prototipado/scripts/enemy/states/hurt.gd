extends State

func enter():
	var player = entity.player
	
	var knockback = 150
	
	var direction = entity.global_position - player.global_position #obtengo un vector con cordenadas 
	direction = direction.normalized()
	
	entity.velocity = direction * knockback
	
	if entity.health <= 0:
		state_machine.change_state(state_machine.get_node("Death"))
	else:
		state_machine.change_state(state_machine.get_node("Chase")) #cuando tengamos hecho el "chase" deberiamos cambiar a chase <---
