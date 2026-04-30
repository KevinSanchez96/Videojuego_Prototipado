extends State

func enter():
	var enemy = get_parent().get_parent()
	var player = enemy.player
	
	var knockback = 150
	
	var direction = enemy.global_position - player.global_position #obtengo un vector con cordenadas 
	direction = direction.normalized()
	
	enemy.velocity = direction * knockback
	
	if enemy.health <= 0:
		get_parent().change_state(get_parent().get_node("Death"))
	else:
		get_parent().change_state(get_parent().get_node("Idle")) #cuando tengamos hecho el "chase" deberiamos cambiar a chase <---
