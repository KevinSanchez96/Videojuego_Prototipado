extends State

@onready var cooldown_timer = $AttackCooldown
var attack_cooldown = 1.0
var can_attack = true

func enter():
	entity.velocity = Vector2.ZERO

func update(delta):
	if !entity.player_in_attack_range:
		state_machine.change_state(state_machine.get_node("Chase"))
		return
	
	if can_attack:
		can_attack = false
		print ("Ataque")
		cooldown_timer.start()


func _on_attack_cooldown_timeout() -> void:
	can_attack = true
