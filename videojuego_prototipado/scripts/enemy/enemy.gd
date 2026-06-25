extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("player") # para tener una referencia del player y conocer su ubicacion por ejemplo.
@onready var state_machine = $State_Machine
@onready var state_speed = $State_Machine/Chase
@onready var coin = preload("res://scenes/moneda/moneda.tscn")
@onready var attack_direction = $AreaAttack

@export var max_health = 100

enum Elemento{
	AGUA,
	FUEGO,
	TIERRA,
	VIENTO,
	NORMAL
}

var health = 0
var hurt_time = 0.0
var hurt_duration = 0.3
var attack = 3
var tiempo_efecto = 0.0
var daño_efecto = 0.0
var velocidad_normal = 120
var direccion_mirada = Vector2.DOWN

var estoy_quemado = false
var estoy_cogelado = false
var chase = false
var spawn_point = false
var can_attack = true
var i_die = false

var mi_elemento := Elemento.NORMAL


func _ready():
	health = max_health
	for state in state_machine.get_children():
		if state is State:
			state.entity = self
			state.state_machine = state_machine
	
	$CollisionShape2D.disabled = true
	
	state_machine.change_state($State_Machine/Sleep)

func take_damage(amount, elemento_ataque = -1):
	if health <= 0:
		return
	var daño_final = amount
	if mi_elemento != Cards.Elemento.NORMAL:
		if mi_elemento == elemento_ataque:
			daño_final *= 0.75
	health -= daño_final
	#print(health)
	#print("Daño:", daño_final)
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
	
	if estoy_quemado == true:
		tiempo_efecto -= delta
		if tiempo_efecto <= 0 or i_die:
			estoy_quemado = false
			$TiempoQuemadura.stop()
	if is_instance_valid(player):
		direccion_mirada = (player.get_global_position() - global_position).normalized()

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

func _on_area_attack_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(attack)
