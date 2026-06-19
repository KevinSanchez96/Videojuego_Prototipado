extends Node
# Creación de un DeckManager porque con la UI no funcionaba
var current_slot = 0
var deck_ui
var combo_en_progreso = false
var combo_actual = combos.Nop
var combo_timer = 0.0
var mazo_cartas = []
var ultimo_slot_usado := -1
var combo_inicio = -1
var combo_slot_actual = -1


func _ready() -> void:
	if mazo_cartas.is_empty():
		crear_mazo_inicial()
func _process(delta: float) -> void:
	actualizar_combo(delta)

enum combos{Nop, Torrente, Llamarada, Terremoto, Huracan, Helada, Erupcion}

func set_deck(deck):# Seteamos el deck que creamos para que lo
	deck_ui = deck  # tome desde la UI que tenemos

func get_next_card():
	if mazo_cartas.is_empty():
		return null
	var attempts := 0
	while attempts < mazo_cartas.size():
		var carta = mazo_cartas[current_slot]
		if carta != null:
			ultimo_slot_usado = current_slot
			registrar_carta_usada()
			current_slot += 1
			if current_slot >= mazo_cartas.size():
				current_slot = 0
			return carta
		current_slot += 1
		if current_slot >= mazo_cartas.size():
			current_slot = 0
		attempts += 1
	return null

func get_deck_sequence():
	var sequence = []
	for data in mazo_cartas:
		if data == null:
			sequence.append("null")
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
func iniciar_combo(combo):
	combo_en_progreso = true
	combo_timer = 1.5
	combo_actual = combo
func finalizar_combo():
	combo_en_progreso = false
	combo_actual = combos.Nop
	combo_slot_actual = -1
	combo_timer = 0.0
func actualizar_combo(delta):
	if !combo_en_progreso:
		return
	combo_timer -= delta
	if combo_timer <= 0:
		finalizar_combo()

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
	if !combo_en_progreso:
		return damage
	if combo_activo == combos.Nop:
		return damage
	if !carta_en_combo(ultimo_slot_usado, combo_activo):
		return damage
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
		null,
		{"elemento": Cards.Elemento.AGUA, "tipo": Cards.CardType.ATAQUE_DEBIL},
		{"elemento": Cards.Elemento.AGUA, "tipo": Cards.CardType.ATAQUE_DEBIL},
		{"elemento": Cards.Elemento.AGUA, "tipo": Cards.CardType.ATAQUE_FUERTE},
		null]

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

func registrar_carta_usada():
	var combo = get_combo_activo()
	if combo == combos.Nop:
		return
	if !combo_en_progreso:
		if ultimo_slot_usado == combo_inicio:
			combo_en_progreso = true
			combo_actual = combo
			combo_slot_actual = combo_inicio
			combo_timer = 1.5
			iniciar_combo(combo)
		if combo_en_progreso:
			if ultimo_slot_usado == combo_slot_actual + 1:
				combo_slot_actual += 1
				if combo_slot_actual == get_ultimo_slot_combo(combo_actual):
					finalizar_combo()

func resetear():
	mazo_cartas.clear()
	crear_mazo_inicial()
	current_slot = 0
	combo_actual = combos.Nop
	combo_en_progreso = false
	combo_timer = 0.0
