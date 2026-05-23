extends Node
# Creación de un DeckManager porque con la UI no funcionaba
var current_slot = 0
var deck_ui

func set_deck(deck):# Seteamos el deck que creamos para que lo
	deck_ui = deck  # tome desde la UI que tenemos

func get_next_card():# Avanzamos entre slots, no entre cartas
	if deck_ui == null:
		#print("Deck es nulo") Validaciones Xd
		return null
	
	var slots = deck_ui.get_children()
	#if slots.is_empty():
		##print("no hay slots") Más validaciones
		#return null
	var attempts := 0 # Con esta var nos aseguramos de no estar
	# infinitamente en un mismo lugar del while
	while attempts < slots.size(): # Bucle para avanzar y volver entre los slots
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
		#print("no hay deck") +validaciones 
		return sequence
		
	var slots = deck_ui.get_children()
	#print("slots encontrados", slots.size()) Validaciones por monton
	
	for slot in slots:
		#print("Slot:", slot,name) Otras validaciones
		#print("Hijos:", slot.get_child_count())
		
		if slot.get_child_count() == 0:
			continue
		var card = slot.get_child(0)
		#print(card)  Validaciones para saber si funcionaba
		#print(card.get_class())
		#print("carta encontrada:", card.name)
		sequence.append(card.tipo_carta)
	#print("secuencia final:", sequence) Más validaciones xd
	return sequence
