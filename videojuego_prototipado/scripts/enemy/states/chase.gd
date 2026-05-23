extends State

var speed = 120
var stop_distance = 20

func update(delta):
	var player = entity.player
	
	if entity.player_in_attack_range:
		state_machine.change_state(state_machine.get_node("Attack"))
		return
	var targetplayer = player.get_node("Marker2D")
	var targetenemy = entity.get_node("Marker2D")
	var distance = targetenemy.global_position.distance_to(player.get_node("Marker2D").global_position)
	
	if distance < stop_distance:
		entity.velocity = Vector2.ZERO
		return
	
	var direction = targetplayer.global_position - targetenemy.global_position
	direction = direction.normalized()
	entity.velocity = direction * speed
