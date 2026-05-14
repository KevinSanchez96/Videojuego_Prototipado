extends State

#se crea una variable para poder determinar el tiempo del ataque
@export var attack_duration := 0.2
@export var inertia = 150
var timer

#comienza el conteo de la duracion del ataque
#una vez entra al estado attack, la espada aparece momentaneamente para crear
#... una ilusion de que el personaje esta atacando. En un futuro se cambiara por la animacion de ataque.

func enter():
	timer = attack_duration
	_use_next_attack()
	entity.sword.get_node("Sprite2D").visible = true
	entity.sword.monitoring = true
	entity.can_hit = true
	
#una vez el comienza la "animacion", empieza el conteo del timer
#creamos el pequeño desplazamiento dependiendo donde quedo el last direction
func update(delta):
	var dir = (entity.get_global_mouse_position() - entity.global_position).normalized()
	timer -= delta
	entity.velocity = dir * inertia
#cuando se termina el timer , queda en idle el player
	if(timer <= 0):
		get_parent().change_state(get_parent().get_node("Idle"))

#sale del estado de Attack , se vuelve invisible de nuevo la sword
func exit():
	entity.sword.get_node("Sprite2D").visible = false
	entity.sword.monitoring = false
	entity.can_hit = false

func _use_next_attack(): #Función que devuelve, según el tipo de carta cuanto daño hacemos
	var card = DeckManager.get_next_card()
	var sequence = DeckManager.get_deck_sequence()
	print(sequence)
	if sequence == [card.CardType.ataque_debil, card.CardType.ataque_debil, card.CardType.ataque_fuerte]:
		#print("Combo")
		entity.ataque_combo()
		return
	if card == null:
		return
	match card.tipo_carta:
		card.CardType.ataque_debil:
			entity.ataque_debil()
			
		card.CardType.ataque_fuerte:
			entity.ataque_fuerte()
