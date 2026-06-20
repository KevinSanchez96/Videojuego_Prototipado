extends StaticBody2D

@onready var label = $Label
@onready var player = get_tree().get_first_node_in_group("player")
@onready var confirmacion_mensage = $"Mensaje de confirmación"

var player_cerca = false
var ui_open = false

func _ready() -> void:
	label.visible = false
	confirmacion_mensage.hide()

func _process(delta: float) -> void:
	if player_cerca and Input.is_action_just_pressed("interact") and player.coins >= 2 and ui_open == false:
		abrir()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_cerca = true
		label.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_cerca = false
		label.visible = false

func _on_cancelar_pressed() -> void:
	confirmacion_mensage.hide()
	player.control_habilitado = true

func _on_aceptar_pressed() -> void:
	if player.coins >= 2:
		player.add_coin(-2)
		player.health += 20

func abrir():
	confirmacion_mensage.show()
	ui_open = true
	player.control_habilitado = false
