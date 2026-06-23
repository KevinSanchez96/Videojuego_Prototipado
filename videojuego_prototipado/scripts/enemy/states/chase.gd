extends State

var speed = 120
var attack_distance = 30

func enter():
	entity.chase = true

func update(delta):
	var player = entity.player
	
	if !is_instance_valid(player):
		return
	
	var distance = entity.global_position.distance_to(player.global_position)
	
	if distance <= attack_distance:
		entity.chase = false
		entity.velocity = Vector2.ZERO
		state_machine.change_state(state_machine.get_node("Attack"))
		return
	
	var direction = player.global_position - entity.global_position
	direction = direction.normalized()
	
	#entity.look_at(player.global_position)
	entity.velocity = direction * speed
	
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			$"../../Sprite2D/AnimationPlayer".play("walk_right")
		else:
			$"../../Sprite2D/AnimationPlayer".play("walk_left")
	else:
		if direction.y > 0:
			$"../../Sprite2D/AnimationPlayer".play("walk_front")
		else:
			$"../../Sprite2D/AnimationPlayer".play("walk_detras")
