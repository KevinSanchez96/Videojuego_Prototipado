extends State

@onready var cooldown_timer = $AttackCooldown

var exit_attack_distance = 50

func enter():
	entity.velocity = Vector2.ZERO

func update(delta):
	var player = entity.player
	
	if player.die:
		return
	
	var distance = entity.global_position.distance_to(player.global_position)

	if distance > exit_attack_distance:
		state_machine.change_state(state_machine.get_node("Chase"))
		return
	
	entity.velocity = Vector2.ZERO
	
	entity.attack_direction.rotation = entity.direccion_mirada.angle() + PI
	
	if entity.can_attack:
		if abs(entity.direccion_mirada.x) > abs(entity.direccion_mirada.y):
			if entity.direccion_mirada.x > 0:
				$"../../Sprite2D/AnimationPlayer".play("attack_right")
			else:
				$"../../Sprite2D/AnimationPlayer".play("attack_left")
		else:
			if entity.direccion_mirada.y > 0:
				$"../../Sprite2D/AnimationPlayer".play("attack_front")
			else:
				$"../../Sprite2D/AnimationPlayer".play("attack_detras")
				
		cooldown_timer.start()
		entity.can_attack = false

func _on_attack_cooldown_timeout() -> void:
	entity.can_attack = true
