extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("player") # para tener una referencia del player y conocer su ubicacion por ejemplo.
@onready var state_machine = $State_Machine
@onready var state_speed = $State_Machine/Chase

@export var max_health = 100 # vida maxima editable
@onready var coin = preload("res://scenes/moneda/moneda.tscn")

var health = 0
var hurt_time = 0.0
var hurt_duration = 0.15
var attack = 3

var estoy_quemado = false
var estoy_cogelado = false
var tiempo_efecto = 0.0
var daño_efecto = 0.0
var velocidad_normal = 120


func _ready():
	health = max_health
	for state in state_machine.get_children():
		if state is State:
			state.entity = self
			state.state_machine = state_machine
	
	$CollisionShape2D.disabled = true
	$Animacion.visible = false
	
	state_machine.change_state($State_Machine/Sleep)
	

func take_damage(amount):
	
	if health <= 0:
		return
	health -= amount
	print(health)
	hurt_time = hurt_duration
	
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
		$Animacion.play("hurt")
		if hurt_time <= 0:
			$Animacion.play("walk")
	
	if estoy_quemado == true:
		tiempo_efecto -= delta
		if tiempo_efecto <= 0:
			estoy_quemado = false
			$TiempoQuemadura.stop()
	

func _on_detection_spawn_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$State_Machine.change_state($State_Machine/Spawn)

func aplicar_quemadura(duracion, daño):
	tiempo_efecto = duracion
	daño_efecto = daño
	if estoy_quemado == false:
		estoy_quemado = true
		$TiempoQuemadura.start()
func _on_tiempo_quemadura_timeout() -> void:
	if estoy_quemado:
		take_damage(daño_efecto)
func aplicar_congelacion(duracion, daño):
	tiempo_efecto = duracion
	daño_efecto = daño
	if estoy_cogelado == false:
		estoy_cogelado = true
		state_speed.speed = velocidad_normal * 0.2
		$TiempoCongelado.start()
func _on_tiempo_congelado_timeout() -> void:
	estoy_cogelado = false
	state_speed.speed = velocidad_normal
