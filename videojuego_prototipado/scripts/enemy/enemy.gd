extends CharacterBody2D

@export var player : Node2D # para tener una referencia del player y conocer su ubicacion por ejemplo.
@export var max_health = 100 # vida maxima editable

var health = 0
var hurt_time = 0.0
var hurt_duration = 0.15

func _ready():
	health = max_health
	$State_Machine.change_state($State_Machine/Idle)

func take_damage(amount):
	if health <= 0:
		return
		
	health -= amount
	hurt_time = hurt_duration
	$Sprite2D.modulate = Color(1,0,0)
	
	if health <= 0:
		die()
		return
	
	$State_Machine.change_state($State_Machine/Hurt)

func die():
	$State_Machine.change_state($State_Machine/Death)

func is_on_screen():
	return $VisibleOnScreenNotifier2D.is_on_screen()

func _physics_process(delta):
	move_and_slide()
	
	velocity = velocity * 0.9
	
	if hurt_time > 0:
		hurt_time -= delta
		
		if hurt_time <= 0:
			$Sprite2D.modulate = Color(1,1,1)
