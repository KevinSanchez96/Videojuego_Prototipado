extends State

@onready var cooldown_timer = $AttackCooldown

var can_attack = true
var exit_attack_distance = 70

func enter():
	entity.velocity = Vector2.ZERO

func update(delta):
	var player = entity.player
	
	if player == null:
		return
	
	var distance = entity.global_position.distance_to(player.global_position)

	if distance > exit_attack_distance:
		state_machine.change_state(state_machine.get_node("Chase"))
		return
	
	entity.velocity = Vector2.ZERO

	if can_attack:
		can_attack = false
		entity.player.take_damage(entity.attack)
		cooldown_timer.start()

func _on_attack_cooldown_timeout() -> void:
	can_attack = true
