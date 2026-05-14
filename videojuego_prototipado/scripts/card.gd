extends TextureRect

enum CardType{ataque_debil, ataque_fuerte}

var sostener = false
var offset = Vector2.ZERO
var posicion_original
@export var tipo_carta : CardType

@onready var deck = $"../../../../DeckPanel/Deck" ## sube 4 niveles para llegar a MainUI y luego toma al hijo Deck panel y por ultimo al Deck. Toma referencia al DECK
@onready var slot_original = $".."
@onready var reward_selection = $"../../"

func _ready() -> void:
	if tipo_carta == 0:
		modulate = Color.BLUE
	elif tipo_carta == 1:
		modulate = Color.RED
		
	posicion_original = slot_original.global_position
	
func _gui_input(event: InputEvent) -> void:
	print("RECIBI INPUT")
	if event is InputEventMouseButton: ## es un evento de input de mouse?
		if event.button_index == MOUSE_BUTTON_LEFT: ## lo que se apreta es el boton izquierdo? 
			if event.pressed: ## el evento es presionar dicho click? 
				sostener = true
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
			print("TOCANDO:", slot.name)
			if slot.get_child_count() == 0: ## si el slot en el cual se crea la interseccion , tiene 0 hijos , osea no tiene nodo hijos , es que se puede hacer el snap
				reparent(slot)# se agrega este nodo(carta) al deck
				position =Vector2.ZERO # se reinicia a la posicion 0,0 del nuevo nodo padre(deck)
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
	position = Vector2.ZERO
	
func destruir_carta_reward():
	for reward_slot in reward_selection.get_children():
		reward_slot.queue_free()
