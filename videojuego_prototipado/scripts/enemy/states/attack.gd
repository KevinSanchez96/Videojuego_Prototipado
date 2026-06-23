extends State

@onready var cooldown_timer = $AttackCooldown

var can_attack = true
var exit_attack_distance = 40

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

	if can_attack:
		if abs(entity.direccion_mirada.x) > abs(entity.direccion_mirada.y):
			if entity.direccion_mirada.x > 0:
				entity.attack_direction.rotation_degrees = 180
				$"../../Sprite2D/AnimationPlayer".play("attack_right")
			else:
				entity.attack_direction.rotation_degrees = 0
				$"../../Sprite2D/AnimationPlayer".play("attack_left")
		else:
			if entity.direccion_mirada.y > 0:
				entity.attack_direction.rotation_degrees = -90
				$"../../Sprite2D/AnimationPlayer".play("attack_front")
			else:
				entity.attack_direction.rotation_degrees = 90
				$"../../Sprite2D/AnimationPlayer".play("attack_detras")
				
		#entity.player.take_damage(entity.attack)
		cooldown_timer.start()
		can_attack = false

func _on_attack_cooldown_timeout() -> void:
	can_attack = true
