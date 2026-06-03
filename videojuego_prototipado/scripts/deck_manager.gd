extends Node
# Creación de un DeckManager porque con la UI no funcionaba
var current_slot = 0
var deck_ui

enum combos{Nop, Torrente, Llamarada, Terremoto, Huracan, Helada, Erupcion}

func set_deck(deck):# Seteamos el deck que creamos para que lo
	deck_ui = deck  # tome desde la UI que tenemos

func get_next_card():# Avanzamos entre slots, no entre cartas
	if deck_ui == null:
		return null
	var slots = deck_ui.get_children()
	var attempts := 0
	while attempts < slots.size():
		var slot = slots[current_slot]
		current_slot += 1
		if current_slot >= slots.size():
			current_slot = 0
		if slot.get_child_count() > 0:
			return slot.get_child(0)
		attempts += 1
	return null

func get_deck_sequence():
	var sequence = []
	if deck_ui == null:
		return sequence
	var slots = deck_ui.get_children()
	for slot in slots:
		if slot.get_child_count() == 0:
			continue
		var card = slot.get_child(0)
		var elemento = ""
		match card.mi_elemento:
			card.ElementoType.agua:
				elemento = "agua"
			card.ElementoType.fuego:
				elemento = "fuego"
			card.ElementoType.tierra:
				elemento = "tierra"
			card.ElementoType.viento:
				elemento = "viento"
		match card.tipo_carta:
			card.CardType.ataque_debil:
				elemento += "_debil"
			card.CardType.ataque_fuerte:
				elemento += "_fuerte"
		sequence.append(elemento)
	return sequence

func get_combo_activo():
	var sequence = get_deck_sequence()
	if sequence == ["agua_debil", "agua_debil", "agua_fuerte"]:
		return combos.Torrente
	if sequence == ["fuego_debil", "fuego_debil", "fuego_fuerte"]:
		return combos.Llamarada
	if sequence == ["tierra_debil", "tierra_debil", "tierra_fuerte"]:
		return combos.Terremoto
	if sequence == ["viento_debil", "viento_debil", "viento_fuerte"]:
		return combos.Huracan
	if sequence == ["viento_debil", "agua_debil", "viento_fuerte", "agua_fuerte"]:
		return combos.Helada
	if sequence == ["fuego_fuerte", "tierra_fuerte", "fuego_debil", "tierra_fuerte"]:
		return combos.Erupcion
	return combos.Nop
