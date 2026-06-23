extends State

var timer_dead := 0.0

func enter():
	entity.velocity = Vector2.ZERO
	
	if abs(entity.direccion_mirada.x) > abs(entity.direccion_mirada.y):
		if entity.direccion_mirada.x > 0:
			$"../../Sprite2D/AnimationPlayer".play("dead_right")
		else:
			$"../../Sprite2D/AnimationPlayer".play("dead_left")
	else:
		if entity.direccion_mirada.y > 0:
			$"../../Sprite2D/AnimationPlayer".play("dead_right")
		else:
			$"../../Sprite2D/AnimationPlayer".play("dead_left")
	
	timer_dead = 1.4
	

func update(delta):
	timer_dead -= delta
	if timer_dead <= 0:
		entity.queue_free()
