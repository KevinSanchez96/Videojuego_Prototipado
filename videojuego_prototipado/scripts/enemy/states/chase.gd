extends State

var speed = 120
var attack_distance = 110

func update(delta):
	var player = entity.player
	
	if player == null:
		return
	
	var distance = entity.global_position.distance_to(player.global_position)
	
	if distance <= attack_distance:
		entity.velocity = Vector2.ZERO
		state_machine.change_state(state_machine.get_node("Attack"))
		return
	
	var direction = player.global_position - entity.global_position
	direction = direction.normalized()

	entity.velocity = direction * speed
