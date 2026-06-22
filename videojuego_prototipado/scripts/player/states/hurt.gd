extends State

var timer = 0.0

func enter():
	entity.hurt = true
	entity.velocity = Vector2.ZERO
	if abs(entity.direccion_mirada.x) > abs(entity.direccion_mirada.y):
		if entity.direccion_mirada.x > 0:
			$"../../Sprite2D/AnimationPlayer".play("HurtRight")
		else:
			$"../../Sprite2D/AnimationPlayer".play("HurtLeft")
	else:
		if entity.direccion_mirada.y > 0:
			$"../../Sprite2D/AnimationPlayer".play("HurtFrente")
		else:
			$"../../Sprite2D/AnimationPlayer".play("HurtDetras")
	timer = 0.6

func update(delta):
	timer -= delta
	if timer <= 0:
		entity.hurt = false
		state_machine.change_state(state_machine.get_node("Idle"))
