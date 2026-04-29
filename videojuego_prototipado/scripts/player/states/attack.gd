extends State

#se crea una variable para poder determinar el tiempo del ataque
@export var attack_duration := 0.2
var timer

#comienza el conteo de la duracion del ataque
#una vez entra al estado attack, la espada aparece momentaneamente para crear
#... una ilusion de que el personaje esta atacando. En un futuro se cambiara por la animacion de ataque.

func enter():
	timer = attack_duration
	entity.sword.get_node("Sprite2D").visible = true
	entity.sword.monitoring = true
	entity.can_hit = true
	
#creamos una variable en player para obtener la ultima direccion en la que quedo el player
# y posicionamos la sword
	if entity.last_direction.x > 0:
		entity.sword.position = Vector2(5,0)
		entity.sword.get_node("Sprite2D").flip_v = false
	else:
		entity.sword.position = Vector2(-210,0)
		entity.sword.get_node("Sprite2D").flip_v = true
		
#una vez el comienza la "animacion", empieza el conteo del timer
#creamos el pequeño desplazamiento dependiendo donde quedo el last direction
func update(delta):
	timer -= delta
	entity.velocity = entity.last_direction * 150
#cuando se termina el timer , queda en idle el player
	if(timer <= 0):
		get_parent().change_state(get_parent().get_node("Idle"))

#sale del estado de Attack , se vuelve invisible de nuevo la sword
func exit():
	entity.sword.get_node("Sprite2D").visible = false
	entity.sword.monitoring = false
	entity.can_hit = false
	
