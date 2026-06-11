extends CharacterBody2D

@export var speed = 400
@export var max_health = 100
@onready var state_machine = $State_Machine
@onready var sword = $Sprite2D/Sword
@onready var HUD = get_tree().current_scene.get_node("CanvasLayer/HUD")
@onready var player = get_tree().get_first_node_in_group("player")
@export var attack_cooldown = 0.5
@export var attack_timer = 0.0

var mazo : Array[Cards] = []

@onready var mouse_position = get_global_mouse_position()
#var last_direction = get_global_mouse_position()
var can_hit = false
var control_habilitado = true
@export var coins = 5
var attack_damage : int
var health
var timer_reset = 3
var direccion_mirada := Vector2.RIGHT


func _ready():
	health = max_health
	for state in state_machine.get_children():
		state.entity = self
		state.state_machine = state_machine
		
	await get_tree().process_frame
	HUD.actualizar_coins(coins)
	state_machine.change_state($State_Machine/Idle)
	
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
	if !control_habilitado:
		velocity = Vector2.ZERO
		return
	if Input.is_action_just_pressed("attack"):
		if attack_timer > 0:
			return
		attack_timer = get_attack_cooldown()
		state_machine.change_state($State_Machine/Attack)
	direccion_mirada = (get_global_mouse_position() - global_position).normalized()
	actualizar_iddle()


func take_damage(amount):
	health -= amount
	if health <= 0:
		state_machine.change_state(state_machine.get_node("Die"))
		return
	print(health)
	state_machine.change_state(state_machine.get_node("Hurt"))

func _on_sword_body_entered(body: Node2D) -> void:
	print("player golpeando", self)
	print("attack_damage al golpear:", attack_damage)
	if body.has_method("take_damage") and can_hit:
		body.take_damage(attack_damage)
		can_hit = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("monedas"):
		get_tree().call_group("monedas", "count_coin")

#función para que el pj esté mirando siempre al ratón
func _look_at_mouse(mouse_pos):
	#var mouse_pos = get_global_mouse_position()
	get_node("Sprite2D").look_at(mouse_pos)

func add_coin(amount):
	coins += amount
	HUD.actualizar_coins(coins)

func get_coins():
	return coins

func ataque_debil(damage):
	attack_damage = damage
	print("Player", self)
func ataque_fuerte(damage):
	attack_damage = damage
	print("player:", self)
func get_attack_cooldown():
	if DeckManager.combo_en_progreso == true:
		return 0.2
	return 0.5
func actualizar_animacion():
	var moviendo = velocity.length() > 0
	
	if abs(direccion_mirada.x) > abs(direccion_mirada.y):
		if direccion_mirada.x > 0:
			$Animaciones.play("walk_derecha" if moviendo else "iddle_derecha")
		else:
			$Animaciones.play("walk_izquierda" if moviendo else "iddle_izquierda")
	else:
		if direccion_mirada.y > 0:
			$Animaciones.play("walk_frente" if moviendo else "iddle_frente")
		else:
			$Animaciones.play("walk_detras" if moviendo else "iddle_detras")
func actualizar_iddle():
	if abs(direccion_mirada.x) > abs(direccion_mirada.y):
		if direccion_mirada.x > 0:
			$Animaciones.play("iddle_derecha")
		else:
			$Animaciones.play("iddle_izquierda")
	else:
		if direccion_mirada.y > 0:
			$Animaciones.play("iddle_frente")
		else:
			$Animaciones.play("iddle_detras")
