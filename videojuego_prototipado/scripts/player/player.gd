extends CharacterBody2D

@export var speed = 400
@onready var state_machine = $State_Machine
@onready var sword = $Sword

var last_direction = Vector2.RIGHT

func _ready():
	for state in state_machine.get_children():
		state.entity = self
	
	state_machine.change_state($State_Machine/Idle)
	
func _physics_process(delta):
	move_and_slide()

func _process(delta):
	if Input.is_action_just_pressed("attack"):
		state_machine.change_state($State_Machine/Attack)
