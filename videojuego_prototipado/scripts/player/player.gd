extends CharacterBody2D

@export var speed = 400
@onready var state_machine = $State_Machine
@onready var sword = $Sprite2D/Sword
@onready var HUD = get_tree().current_scene.get_node("CanvasLayer/HUD")


@onready var mouse_position = get_global_mouse_position()
#var last_direction = get_global_mouse_position()
var can_hit = false
var control_habilitado = true
var coins = 0
var attack_damage : int


func _ready():
	for state in state_machine.get_children():
		state.entity = self
	
	state_machine.change_state($State_Machine/Idle)
	
func _physics_process(delta):
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
		state_machine.change_state($State_Machine/Attack)

func _on_sword_body_entered(body: Node2D) -> void:
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
	print(HUD)
	HUD.actualizar_coins(coins)

func ataque_debil(): #Funciones para sabe cuanto daño se hace
	attack_damage = 10
func ataque_fuerte():
	attack_damage = 20
func ataque_combo():
	attack_damage = 100
