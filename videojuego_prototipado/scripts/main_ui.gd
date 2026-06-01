extends Control

@onready var player = get_tree().get_first_node_in_group("player")
@onready var slots = $ShopPanel/RewardSelection.get_children()

func _ready():
	visible = false
	gerear_tienda()

func _process(delta: float) -> void:
	if visible and Input.is_action_just_pressed("ui_exit"):
		cerrar()

func abrir():
	visible = true
	player.control_habilitado = false
	
func cerrar():
	visible = false
	player.control_habilitado = true

func gerear_tienda():
	for slot in slots:
		if slot.get_child_count() == 0:
			continue
		var card = slot.get_child(0)
		card.elegir_elemento()
		card.actualizar_sprite()
