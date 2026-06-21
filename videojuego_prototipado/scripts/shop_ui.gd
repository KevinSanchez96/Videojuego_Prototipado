extends Control

var reward_scene = preload("res://scenes/reward_selection_ui.tscn")
@onready var player = get_tree().get_first_node_in_group("player")
@onready var msg_container = $MensajePanel
var shop_abierto = false

func _ready():
	visible = false
	msg_container.hide()

func _process(delta: float) -> void:
	if visible and Input.is_action_just_pressed("ui_exit"):
		cerrar()

func mostrar_error():
	msg_container.show()

func abrir():
	visible = true
	player.control_habilitado = false
	shop_abierto = true

func cerrar():
	visible = false
	player.control_habilitado = true
	shop_abierto = false

func _on_buy_basic_button_pressed() -> void:
	if player.get_coins() >= 2:
		var reward_ui = reward_scene.instantiate()
		reward_ui.cantidad_cartas = 2
		reward_ui.shop_ui = self
		player.add_coin(-2)
		get_parent().add_child(reward_ui)
		hide()
	else:
		mostrar_error()

func _on_buy_premium_button_pressed() -> void:
	if player.get_coins() >= 5:
		var reward_ui = reward_scene.instantiate()
		reward_ui.cantidad_cartas = 3
		reward_ui.shop_ui = self
		player.add_coin(-5)
		get_parent().add_child(reward_ui)
		hide()
	else:
		mostrar_error()

func _on_close_button_pressed() -> void:
	cerrar()

func _on_close_button_msg_pressed() -> void:
	msg_container.cerrar()
