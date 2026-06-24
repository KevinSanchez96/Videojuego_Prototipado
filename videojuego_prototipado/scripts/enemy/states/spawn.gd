extends State

var timer_spawn := 0.0

func enter():
	entity.spawn_point = true
	#$"../../Sprite2D/AnimationPlayer".play("spawn")
	
	entity.get_node("CollisionShape2D").set_deferred("disabled",false)
	
	timer_spawn = 0.8

func update(delta):
	timer_spawn -= delta
	
	if timer_spawn <= 0:
		state_machine.change_state(state_machine.get_node("Chase"))
