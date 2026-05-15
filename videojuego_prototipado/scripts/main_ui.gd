extends Control

@onready var player = get_tree().get_first_node_in_group("player")

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
