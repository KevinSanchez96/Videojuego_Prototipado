extends Node
# Creación de un DeckManager porque con la UI no funcionaba
var current_slot = 0
var deck_ui
var combo_timer = 0.0
var combo_activado = false
var mazo_cartas = []
var ultimo_slot_usado := -1
var combo_inicio = -1

func _ready() -> void:
	if mazo_cartas.is_empty():
		crear_mazo_inicial()
func _process(delta: float) -> void:
	actualizar_combo(delta)

enum combos{Nop, Torrente, Llamarada, Terremoto, Huracan, Helada, Erupcion}

func set_deck(deck):# Seteamos el deck que creamos para que lo
	deck_ui = deck  # tome desde la UI que tenemos

func get_next_card():# Avanzamos entre slots, no entre cartas
	if mazo_cartas.is_empty():
		return null
	var attempts := 0
	while attempts < mazo_cartas.size():
		ultimo_slot_usado = current_slot
		var carta = mazo_cartas[current_slot]
		current_slot += 1
		if current_slot >= mazo_cartas.size():
			current_slot = 0
		if carta != null:
			return carta
		attempts += 1
	return null

func get_deck_sequence():
	var sequence = []
	for data in mazo_cartas:
		if data == null:
			continue
		var elemento = ""
		match data["elemento"]:
			Cards.Elemento.AGUA:
				elemento = "agua"
			Cards.Elemento.FUEGO:
				elemento = "fuego"
			Cards.Elemento.TIERRA:
				elemento = "tierra"
			Cards.Elemento.VIENTO:
				elemento = "viento"
		match data["tipo"]:
			Cards.CardType.ATAQUE_DEBIL:
				elemento += "_debil"
			Cards.CardType.ATAQUE_FUERTE:
				elemento += "_fuerte"
		sequence.append(elemento)
	return sequence

func get_combo_activo():
	var sequence = get_deck_sequence()
	var pos = buscar_secuencia(sequence,["agua_debil", "agua_debil", "agua_fuerte"])
	if pos != -1:
		combo_inicio = pos
		return combos.Torrente
	pos = buscar_secuencia(sequence,["fuego_debil", "fuego_debil", "fuego_fuerte"])
	if pos != -1:
		combo_inicio = pos
		return combos.Llamarada
	pos = buscar_secuencia(sequence, ["tierra_debil", "tierra_debil", "tierra_fuerte"])
	if pos != -1:
		combo_inicio = pos
		return combos.Terremoto
	pos = buscar_secuencia(sequence, ["viento_debil", "viento_debil", "viento_fuerte"])
	if pos != -1:
		combo_inicio = pos
		return combos.Huracan
	pos = buscar_secuencia(sequence, ["viento_debil", "agua_debil", "viento_fuerte", "agua_fuerte"])
	if pos != -1:
		combo_inicio = pos
		return combos.Helada
	pos = buscar_secuencia(sequence, ["fuego_fuerte", "tierra_fuerte", "fuego_debil", "tierra_fuerte"])
	if pos != -1:
		combo_inicio = pos
		return combos.Erupcion
	combo_inicio = -1
	return combos.Nop

func iniciar_combo():
	combo_activado = true
	combo_timer = 1.5
func actualizar_combo(delta):
	if combo_activado == true:
		combo_timer -= delta
		if combo_timer <= 0:
			combo_activado = false

func get_tamaño_combo(combo):
	match combo:
		combos.Torrente:
			return 3
		combos.Llamarada:
			return 3
		combos.Terremoto:
			return 3
		combos.Huracan:
			return 3
		combos.Helada:
			return 4
		combos.Erupcion:
			return 4

func get_base_damage(card):
	match card["tipo"]:
		Cards.CardType.ATAQUE_DEBIL:
			return 10
		Cards.CardType.ATAQUE_FUERTE:
			return 20
	return 0
func get_damage(card, combo_activo):
	var damage = get_base_damage(card)
	if !carta_en_combo(ultimo_slot_usado, combo_activo):
		return damage
	match combo_activo:
		combos.Torrente:
			if card["elemento"] == Cards.Elemento.AGUA:
				damage += 15
		combos.Llamarada:
			if card["elemento"] == Cards.Elemento.FUEGO:
				damage += 15
		combos.Terremoto:
			if card["elemento"] == Cards.Elemento.TIERRA:
				damage += 15
		combos.Huracan:
			if card["elemento"] == Cards.Elemento.VIENTO:
				damage += 15
		combos.Helada:
			if card["elemento"] == Cards.Elemento.AGUA or card["elemento"] == Cards.Elemento.VIENTO:
				damage += 15
		combos.Erupcion:
			if card["elemento"] == Cards.Elemento.FUEGO or card["elemento"] == Cards.Elemento.TIERRA:
				damage += 15
	return damage

func crear_mazo_inicial():
	DeckManager.mazo_cartas =[
		{"elemento": Cards.Elemento.NORMAL, "tipo": Cards.CardType.ATAQUE_DEBIL},
		{"elemento": Cards.Elemento.NORMAL, "tipo": Cards.CardType.ATAQUE_FUERTE},
		null, null, null]

func buscar_secuencia(sequence:Array, patron:Array) -> int:
	for i in range(sequence.size() - patron.size() + 1):
		var coincidencia = true
		for j in range(patron.size()):
			if sequence[i+j] != patron[j]:
				coincidencia =false
				break
		if coincidencia:
			return i
	return -1

func get_ultimo_slot_combo(combo):
	return combo_inicio + get_tamaño_combo(combo) - 1

func carta_en_combo(slot_actual, combo) -> bool:
	if combo_inicio == -1:
		return false
	var inicio = combo_inicio
	var fin = combo_inicio + get_tamaño_combo(combo) - 1
	return slot_actual >= inicio and slot_actual <= fin
