extends State

var hurt_duration = 0.5
var timer = 0.0

func enter():
	entity.can_attack = false
	if abs(entity.direccion_mirada.x) > abs(entity.direccion_mirada.y):
		if entity.direccion_mirada.x > 0:
			$"../../Sprite2D/AnimationPlayer".play("hurt_right")
		else:
			$"../../Sprite2D/AnimationPlayer".play("hurt_left")
	else:
		if entity.direccion_mirada.y > 0:
			$"../../Sprite2D/AnimationPlayer".play("hurt_front")
		else:
			$"../../Sprite2D/AnimationPlayer".play("hurt_detras")
	
	var player = entity.player
	var knockback = 50
	
	var direction = entity.global_position - player.global_position #obtengo un vector con cordenadas 
	direction = direction.normalized()
	
	entity.velocity = direction * knockback
	timer = hurt_duration

func update(delta):
	timer -= delta
	
	if timer<=0:
		if entity.health <= 0:
			state_machine.change_state(state_machine.get_node("Death"))
		else:
			state_machine.change_state(state_machine.get_node("Chase")) #cuando tengamos hecho el "chase" deberiamos cambiar a chase <---
