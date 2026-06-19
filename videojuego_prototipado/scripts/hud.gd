extends Control

@onready var player = get_tree().get_first_node_in_group("player")
@onready var coins_label = $CoinsUI/Coins_Label
@onready var barra_vida = $VidaPj
@onready var vida_label = $VidaLabel
@onready var deck_ui = $DeckUI

var card_escene = preload("res://scenes/card.tscn")
var ultimo_slot_resaltado := -1
var ultimo_mazo = []
var ultimo_combo = DeckManager.combos.Nop

func _ready() -> void:
	barra_vida.max_value = player.max_health
	barra_vida.value = player.health
	vida_label.text = str(player.health)
	
	cargar_mazo()
	
	await get_tree().process_frame
	actualizar_carta_actual()

func _process(delta: float) -> void:
	actualizar_vida()
	actualizar_carta_actual()

func actualizar_coins(cantidad):
	coins_label.text = str(cantidad)

func actualizar_vida():
	barra_vida.value = player.health
	vida_label.text = str(player.health)

func cargar_mazo():
	var slots = deck_ui.get_children()
	for i in range(min(slots.size(), DeckManager.mazo_cartas.size())):
		var slot = slots[i]
		for child in slot.get_children():
			child.queue_free()
		var data = DeckManager.mazo_cartas[i]
		if data == null:
			continue
		var carta = card_escene.instantiate()
		slot.add_child(carta)
		carta.position = Vector2.ZERO
		carta.scale = Vector2(0.45,0.45)
		carta.configurar(data["elemento"], data["tipo"])
		carta.mouse_filter = Control.MOUSE_FILTER_IGNORE

func actualizar_carta_actual():
	var slot_resaltado = get_slot_resaltado()
	if ultimo_slot_resaltado == slot_resaltado:
		return
	ultimo_slot_resaltado = slot_resaltado
	var slots = deck_ui.get_children()
	for i in range(slots.size()):
		var slot = slots[i]
		if slot.get_child_count() == 0:
			continue
		var carta = slot.get_child(0)
		var tween = create_tween()
		if i == slot_resaltado:
			tween.tween_property(carta, "position:y", -15, 0.15)
		else:
			tween.tween_property(carta, "position:y", 0, 0.15)

func get_slot_resaltado():
	var slot = DeckManager.current_slot
	for i in range(DeckManager.mazo_cartas.size()):
		if DeckManager.mazo_cartas[slot] != null:
			return slot
		slot += 1
		if slot >= DeckManager.mazo_cartas.size():
			slot = 0
	return 0

func actualizar_mazo():
	cargar_mazo()
	ultimo_slot_resaltado = -1
	actualizar_carta_actual()
	ultimo_combo = -1
