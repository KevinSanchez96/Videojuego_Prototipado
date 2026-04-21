extends CharacterBody2D

@export var speed = 400

@onready var state_machine = $StateMachine

func _ready():
	for state in state_machine.get_children():
		state.entity = self
	
	state_machine.change_state($StateMachine/Idle)
