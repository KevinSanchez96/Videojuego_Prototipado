extends Control

var card_scene = preload("res://scenes/card.tscn")

@onready var reward_container = $Panel/VBoxContainer/RewardContainer
@onready var player = get_tree().get_first_node_in_group("player")
@onready var deck_container = $Panel/VBoxContainer/DeckContainer

var cantidad_cartas := 0

func _ready():
	cargar_mazo()
	DeckManager.set_deck(deck_container)
	if cantidad_cartas > 0:
		generar_cartas(cantidad_cartas)
	
func generar_cartas(cantidad:int):
	for child in reward_container.get_children():
		child.queue_free()

	for i in range(cantidad):
		var carta = card_scene.instantiate()
		reward_container.add_child(carta)
		generar_carta_random(carta)
	
func generar_carta_random(carta):
	var elemento_random = randi_range(0, 4)
	var tipo_random = randi_range(0, 1)

	carta.configurar(
		elemento_random,
		tipo_random
	)
	
func guardar_mazo():
	DeckManager.mazo_cartas.clear()
	
	for slot in deck_container.get_children():
		if slot.name == "TrashSlot":
			continue
		if slot.get_child_count() > 0:
			var carta = slot.get_child(0)
			
			DeckManager.mazo_cartas.append({
				"elemento": carta.elemento,
				"tipo": carta.tipo_carta
			})
		else:
			DeckManager.mazo_cartas.append(null)

func cargar_mazo():
	if DeckManager.mazo_cartas.is_empty():
		return
	var slots = []
	for slot in deck_container.get_children():
		if slot.name != "TrashSlot":
			slots.append(slot)
	for i in range(min(slots.size(), DeckManager.mazo_cartas.size())):
		var data = DeckManager.mazo_cartas[i]
		if data == null:
			continue
		var carta = card_scene.instantiate()
		slots[i].add_child(carta)
		carta.position = Vector2.ZERO
		carta.size = Vector2(120,180)
		
		carta.configurar(
			data["elemento"],
			data["tipo"]
		)

func _on_button_pressed() -> void:
	guardar_mazo()
	queue_free()
	player.control_habilitado = true
