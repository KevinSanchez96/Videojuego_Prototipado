extends Control

@export var player : CharacterBody2D

func _ready():
	visible = false
	
func _process(delta: float) -> void:
	if visible and Input.is_action_just_pressed("ui_exit"):
		cerrar()

func abrir():
	visible = true
	player.control_habilitado = false
	
func cerrar():
	visible = false
	player.control_habilitado = true
