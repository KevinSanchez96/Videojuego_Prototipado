extends CharacterBody2D

@export var speed = 100
@export var max_health = 100
@onready var state_machine = $State_Machine
@onready var HUD = get_tree().current_scene.get_node("CanvasLayer/HUD")
@onready var player = get_tree().get_first_node_in_group("player")
@export var attack_cooldown = 0.5
@export var attack_timer = 0.0
@onready var deck_escene = preload("res://scenes/ver_deck.tscn")

var mazo : Array[Cards] = []

@onready var mouse_position = get_global_mouse_position()
var control_habilitado = true
@export var coins = 5
var attack_damage : int
var health
var timer_reset = 3
var direccion_mirada := Vector2.RIGHT
var atacando = false
var moving = false
var hurt = false
var die = false
var attack_elemento : int = Cards.Elemento.NORMAL
var deck_open = false
var deck_instance = null

func _ready():
	health = max_health
	for state in state_machine.get_children():
		state.entity = self
		state.state_machine = state_machine
		
	await get_tree().process_frame
	HUD.actualizar_coins(coins)
	state_machine.change_state($State_Machine/Idle)
	#$Animaciones_Aura.visible = false
	
func _physics_process(delta):
	if attack_timer >= 0:
		attack_timer -= delta
	if !control_habilitado:
		velocity = Vector2.ZERO
		return
	
	var mouse_pos = get_global_mouse_position()
	move_and_slide()
	_look_at_mouse(mouse_pos)

func _process(delta):
	if Input.is_action_just_pressed("attack") and control_habilitado:
		if attack_timer > 0:
			return
		attack_timer = get_attack_cooldown()
		state_machine.change_state($State_Machine/Attack)
	direccion_mirada = (get_global_mouse_position() - global_position).normalized()
	actualizar_iddle()
	
	if Input.is_action_just_pressed("view_deck"):
		activar_deck()

func take_damage(amount):
	health -= amount
	if health <= 0:
		state_machine.change_state(state_machine.get_node("Die"))
		return
	state_machine.change_state(state_machine.get_node("Hurt"))

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("monedas"):
		get_tree().call_group("monedas", "count_coin")

func _look_at_mouse(mouse_pos):
	get_node("Area2D").look_at(mouse_pos)

func add_coin(amount):
	coins += amount
	HUD.actualizar_coins(coins)

func get_coins():
	return coins

func ataque_debil(damage):
	attack_damage = damage
func ataque_fuerte(damage):
	attack_damage = damage
func get_attack_cooldown():
	if DeckManager.combo_en_progreso == true:
		return 0.2
	return 0.5
func actualizar_animacion():
	var moviendo = velocity.length() > 0
	
	if abs(direccion_mirada.x) > abs(direccion_mirada.y):
		if direccion_mirada.x > 0:
			$Sprite2D/AnimationPlayer.play("move_derecha" if moviendo else "iddle_derecha")
		else:
			$Sprite2D/AnimationPlayer.play("move_izquierda" if moviendo else "iddle_izquierda")
	else:
		if direccion_mirada.y > 0:
			$Sprite2D/AnimationPlayer.play("move_frente" if moviendo else "iddle_frente")
		else:
			$Sprite2D/AnimationPlayer.play("move_detras" if moviendo else "iddle_detras")
func actualizar_iddle():
	if atacando or moving or hurt or die:
		return
	if abs(direccion_mirada.x) > abs(direccion_mirada.y):
		if direccion_mirada.x > 0:
			$Sprite2D/AnimationPlayer.play("iddle_derecha")
		else:
			$Sprite2D/AnimationPlayer.play("iddle_izquierda")
	else:
		if direccion_mirada.y > 0:
			$Sprite2D/AnimationPlayer.play("iddle_frente")
		else:
			$Sprite2D/AnimationPlayer.play("move_detras")
func get_healt():
	return health

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemigos"):
		body.take_damage(attack_damage, attack_elemento)

func activar_deck():
	if deck_open:
		deck_instance.cerrar()
		deck_instance = null
		deck_open = false
		control_habilitado = true
		Engine.time_scale = 1
	else:
		deck_instance = deck_escene.instantiate()
		get_tree().current_scene.add_child(deck_instance)
		deck_open = true
		control_habilitado = false
		Engine.time_scale = 0
