extends Panel
class_name Cards

#valores constantes a traves de nombres descriptivos
enum CardType {
	ATAQUE_DEBIL,
	ATAQUE_FUERTE
}

enum Elemento{
	AGUA,
	FUEGO,
	TIERRA,
	VIENTO,
	NORMAL
}

#drag y drop
var sostener = false
var offset = Vector2.ZERO
@onready var deck = get_tree().get_first_node_in_group("deck_container")
@onready var reward_container = get_tree().get_first_node_in_group("reward_container")
var posicion_original : Vector2
var padre_original : Node

#tooltip
@onready var tooltip = $Tooltip

#tipo cartas
var elemento : Elemento
@export var tipo_carta : CardType
@onready var imagen : TextureRect = $TextureRect

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton: ## es un evento de input de mouse?
		if event.button_index == MOUSE_BUTTON_LEFT: ## lo que se apreta es el boton izquierdo? 
			if event.pressed: ## el evento es presionar dicho click? 
				sostener = true
				
				padre_original = get_parent()
				posicion_original = position
				offset = get_global_mouse_position()-global_position ## guarda la distancia entre el mouse - la posicion global de la carta
			else:
				sostener = false
				snapear()

func _process(delta: float) -> void:
	if sostener:
		global_position = get_global_mouse_position() - offset 
		##si no restamos esto , la posicion de la carta "salta" a la del mouse
		##nosotros queremos que desde donde lo agarre (dentro del rectangulo de la card) se mueva desde ahi.

func snapear():
	var slot_original = get_parent()
	var viene_del_deck = slot_original.get_parent() == deck
	

	for slot in deck.get_children(): ## para cada hijo de deck , se hace el intersects para saber si una card toca un slot del deck
		if get_global_rect().intersects(slot.get_global_rect()):
			if slot.name == "TrashSlot":
				if viene_del_deck:
					queue_free()
					return
			if slot.get_child_count() == 0: ## si el slot en el cual se crea la interseccion , tiene 0 hijos , osea no tiene nodo hijos , es que se puede hacer el snap
				reparent(slot)# se agrega este nodo(carta) al deck
				position = Vector2.ZERO # se reinicia a la posicion 0,0 del nuevo nodo padre(deck)
				if !viene_del_deck:
					destruir_carta_reward()
				return
			else:
				if viene_del_deck:
					var otra_carta = slot.get_child(0)
					otra_carta.reparent(slot_original)
					otra_carta.position = Vector2.ZERO
					
					reparent(slot)
					position = Vector2.ZERO
					return
	if get_parent() != padre_original:
		reparent(padre_original)
	position = posicion_original
	
func destruir_carta_reward():
	for reward_slot in reward_container.get_children():
		reward_slot.queue_free()

#en el reward selection necesitamos esta funcion para cuando instanciemos las cartas en el reward_selection
func configurar(nuevo_elemento:Elemento, nuevo_tipo:CardType):
	elemento = nuevo_elemento
	tipo_carta = nuevo_tipo
	actualizar_sprite()

#se actualizan las imagenes segun lo que salga en el random
func actualizar_sprite():
	if tipo_carta == CardType.ATAQUE_DEBIL and elemento == Elemento.AGUA:
		imagen.texture = preload("res://assets/sprites/sprites cartas/Water-Type-Weak.png")

	elif tipo_carta == CardType.ATAQUE_FUERTE and elemento == Elemento.AGUA:
		imagen.texture = preload("res://assets/sprites/sprites cartas/Water-Type-Strong.png")

	elif tipo_carta == CardType.ATAQUE_DEBIL and elemento == Elemento.FUEGO:
		imagen.texture = preload("res://assets/sprites/sprites cartas/Fire-Type-Weak.png")

	elif tipo_carta == CardType.ATAQUE_FUERTE and elemento == Elemento.FUEGO:
		imagen.texture = preload("res://assets/sprites/sprites cartas/Fire-Type-Strong.png")

	elif tipo_carta == CardType.ATAQUE_DEBIL and elemento == Elemento.TIERRA:
		imagen.texture = preload("res://assets/sprites/sprites cartas/Earth-Type-Weak.png")

	elif tipo_carta == CardType.ATAQUE_FUERTE and elemento == Elemento.TIERRA:
		imagen.texture = preload("res://assets/sprites/sprites cartas/Earth-Type-Strong.png")

	elif tipo_carta == CardType.ATAQUE_DEBIL and elemento == Elemento.VIENTO:
		imagen.texture = preload("res://assets/sprites/sprites cartas/Wind-Type-Weak.png")

	elif tipo_carta == CardType.ATAQUE_FUERTE and elemento == Elemento.VIENTO:
		imagen.texture = preload("res://assets/sprites/sprites cartas/Wind-Type-Strong.png")

	elif tipo_carta == CardType.ATAQUE_DEBIL and elemento == Elemento.NORMAL:
		imagen.texture = preload("res://assets/sprites/sprites cartas/Normal-Type-Weak.png")

	elif tipo_carta == CardType.ATAQUE_FUERTE and elemento == Elemento.NORMAL:
		imagen.texture = preload("res://assets/sprites/sprites cartas/Normal-Type-Strong.png")

func get_tipo_carta() -> String:
	match tipo_carta:
		CardType.ATAQUE_DEBIL:
			return "Débil"
		CardType.ATAQUE_FUERTE:
			return "Fuerte"
	return "Desconocido"
func get_elemento() -> String:
	match elemento:
		Elemento.AGUA:
			return "AGUA"
		Elemento.FUEGO:
			return "FUEGO"
		Elemento.TIERRA:
			return "TIERRA"
		Elemento.VIENTO:
			return "VIENTO"
		Elemento.NORMAL:
			return "NORMAL"
	return "Desconocido"
