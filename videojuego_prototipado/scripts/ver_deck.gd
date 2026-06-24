extends CanvasLayer

@onready var deck_container = $Panel/DeckContainer

var card_scene = preload("res://scenes/card.tscn")

func _ready() -> void:
	cargar_mazo()

func _process(delta: float) -> void:
	pass

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

func cerrar():
	guardar_mazo()
	
	var hud = get_tree().get_first_node_in_group("hud")
	if hud:
		hud.cargar_mazo()
	
	queue_free()
