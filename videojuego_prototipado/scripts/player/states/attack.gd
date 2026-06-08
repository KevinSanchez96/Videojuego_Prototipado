extends State

#se crea una variable para poder determinar el tiempo del ataque
@export var attack_duration = 0.3
@export var inertia = 150

var timer
var health

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
	if card == null:
		return
	var combo = DeckManager.get_combo_activo()
	var damage = DeckManager.get_damage(card, combo)
	print(damage)
	if combo != DeckManager.combos.Nop:
		DeckManager.iniciar_combo()
	if DeckManager.combo_activado == true:
		print("Slot usado:", DeckManager.ultimo_slot_usado)
		print("Tamaño combo:", DeckManager.get_tamaño_combo(combo))
		if DeckManager.ultimo_slot_usado == DeckManager.get_ultimo_slot_combo(combo):
			match combo:
				DeckManager.combos.Torrente:
					crear_torrente()
				DeckManager.combos.Llamarada:
					crear_llamarada()
				DeckManager.combos.Terremoto:
					crear_terremoto()
				DeckManager.combos.Huracan:
					crear_huracan()
				DeckManager.combos.Helada:
					crear_helada()
				DeckManager.combos.Erupcion:
					crear_erupcion()
	match card["tipo"]:
		Cards.CardType.ATAQUE_DEBIL:
			entity.ataque_debil(damage)
			
		Cards.CardType.ATAQUE_FUERTE:
			entity.ataque_fuerte(damage)

func crear_torrente():
	var torrente = preload("res://scenes/combos/torrente.tscn").instantiate()
	var delante = (entity.get_global_mouse_position() - entity.global_position).normalized()
	torrente.direccion = delante
	torrente.global_position = entity.global_position + delante * 50
	get_tree().current_scene.add_child(torrente)
func crear_llamarada():
	var llamarada = preload("res://scenes/combos/llamarada.tscn").instantiate()
	llamarada.global_position = entity.global_position
	get_tree().current_scene.add_child(llamarada)
func crear_terremoto():
	var terremoto = preload("res://scenes/combos/terremoto.tscn").instantiate()
	var delante = (entity.get_global_mouse_position() - entity.global_position).normalized()
	terremoto.global_position = entity.global_position + delante * 100
	get_tree().current_scene.add_child(terremoto)
func crear_huracan():
	var huracan = preload("res://scenes/combos/huracan.tscn").instantiate()
	huracan.creador = entity
	get_tree().current_scene.add_child(huracan)
func crear_helada():
	var helada = preload("res://scenes/combos/helada.tscn").instantiate()
	var delante = (entity.get_global_mouse_position() - entity.global_position).normalized()
	helada.direccion = delante
	helada.global_position = entity.global_position + delante * 100
	get_tree().current_scene.add_child(helada)
func crear_erupcion():
	var erupcion = preload("res://scenes/combos/erupcion.tscn").instantiate()
	var delante = (entity.get_global_mouse_position() - entity.global_position).normalized()
	erupcion.global_position = entity.global_position + delante * 100
	get_tree().current_scene.add_child(erupcion)
