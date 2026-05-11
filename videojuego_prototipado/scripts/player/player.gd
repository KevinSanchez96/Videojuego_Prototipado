extends CharacterBody2D

@export var speed = 400
@onready var state_machine = $State_Machine
@onready var sword = $Sword
var monedas = 0

var last_direction = Vector2.RIGHT
var can_hit = false

func _ready():
	for state in state_machine.get_children():
		state.entity = self
	
	state_machine.change_state($State_Machine/Idle)
	
func _physics_process(delta):
	move_and_slide()

func _process(delta):
	if Input.is_action_just_pressed("attack"):
		state_machine.change_state($State_Machine/Attack)


func _on_sword_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage") and can_hit:
		body.take_damage(20)
		can_hit = false
