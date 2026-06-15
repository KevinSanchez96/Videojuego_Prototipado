extends Control

@onready var player = get_tree().get_first_node_in_group("player")
@onready var coins_label = $CoinsUI/Coins_Label
@onready var barra_vida = $VidaPj

func _ready() -> void:
	barra_vida.max_value = player.max_health
	barra_vida.value = player.health

func _process(delta: float) -> void:
	actualizar_vida()

func actualizar_coins(cantidad):
	coins_label.text = str(cantidad)

func actualizar_vida():
	barra_vida.value = player.health
