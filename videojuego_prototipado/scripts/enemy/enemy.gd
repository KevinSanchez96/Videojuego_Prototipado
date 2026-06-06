extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("player") # para tener una referencia del player y conocer su ubicacion por ejemplo.
@onready var state_machine = $State_Machine

@export var max_health = 100 # vida maxima editable
@onready var coin = preload("res://scenes/moneda/moneda.tscn")

var health = 0
var hurt_time = 0.0
var hurt_duration = 0.15
var attack = 10

func _ready():
	health = max_health
	
	for state in state_machine.get_children():
		if state is State:
			state.entity = self
			state.state_machine = state_machine
	
	$CollisionShape2D.disabled = true
	$Sprite2D.visible = false
	
	state_machine.change_state($State_Machine/Sleep)
	

func take_damage(amount):
	print("Daño recibido:",amount)
	print("Vida antes:",health)
	if health <= 0:
		return
	health -= amount
	print("Vida despues:",health)
	hurt_time = hurt_duration
	$Sprite2D.modulate = Color(1,0,0)
	
	if health <= 0:
		call_deferred("die")
		return
	
	$State_Machine.change_state($State_Machine/Hurt)

func die():

	var new_coin = coin.instantiate()
	new_coin.global_position = global_position
	get_tree().current_scene.add_child(new_coin)
	$State_Machine.change_state($State_Machine/Death)

func _physics_process(delta):
	move_and_slide()
	
	if hurt_time > 0:
		hurt_time -= delta
		
		if hurt_time <= 0:
			$Sprite2D.modulate = Color(1,1,1)
	

func _on_detection_spawn_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$State_Machine.change_state($State_Machine/Spawn)
