extends CharacterBody2D

@export var speed = 400
@onready var state_machine = $State_Machine
@onready var sword = $Sprite2D/Sword

@onready var mouse_position = get_global_mouse_position()
#var last_direction = get_global_mouse_position()
var can_hit = false

func _ready():
	for state in state_machine.get_children():
		state.entity = self
	
	state_machine.change_state($State_Machine/Idle)
	
func _physics_process(delta):
	var mouse_pos = get_global_mouse_position()
	move_and_slide()
	_look_at_mouse(mouse_pos)

func _process(delta):
	if Input.is_action_just_pressed("attack"):
		state_machine.change_state($State_Machine/Attack)

func _on_sword_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage") and can_hit:
		body.take_damage(20)
		can_hit = false

#función para que el pj esté mirando siempre al ratón
func _look_at_mouse(mouse_pos):
	#var mouse_pos = get_global_mouse_position()
	get_node("Sprite2D").look_at(mouse_pos)
