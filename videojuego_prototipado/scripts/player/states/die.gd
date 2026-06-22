extends State

var timer := 0.0

func enter():
	entity.die = true
	entity.velocity = Vector2.ZERO
	if abs(entity.direccion_mirada.x) > abs(entity.direccion_mirada.y):
		if entity.direccion_mirada.x > 0:
			$"../../Sprite2D/AnimationPlayer".play("deadright")
		else:
			$"../../Sprite2D/AnimationPlayer".play("deadleft")
	else:
		if entity.direccion_mirada.y > 0:
			$"../../Sprite2D/AnimationPlayer".play("deadright")
		else:
			$"../../Sprite2D/AnimationPlayer".play("deadleft")
	
	timer = 1.8


func update(delta):
	timer -= delta
	if timer <= 0.0:
		entity.queue_free()
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
