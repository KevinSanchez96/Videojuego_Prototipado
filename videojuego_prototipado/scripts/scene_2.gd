extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var fade = get_tree().current_scene.get_node("CanvasLayer/Control/ColorRect")
@onready var camera = get_viewport().get_camera_2d()
@onready var timer = $Timer
@onready var label = $CanvasLayer/Label
@onready var centro_area_enemies = $SpawnEnemies.global_position
@onready var area_enemies = $SpawnEnemies/Area2D/CollisionShape2D.shape.size
@export var enemy_scene : PackedScene


var scene1
var destino
var teleportando = false
var combate_terminado = false
var countdown

func _ready():
	scene1 = get_tree().current_scene.get_node("Scene1")
	destino = scene1.get_spawn()
	generar_piso()

func obtener_posicion_spawn(): #esta funcion nos devolvera un vector2 con una posicion random dentro del area del respawn de enemigos
	var min_x = centro_area_enemies.x - area_enemies.x/2
	var max_x = centro_area_enemies.x + area_enemies.x/2
	
	var min_y = centro_area_enemies.y - area_enemies.y/2
	var max_y = centro_area_enemies.y + area_enemies.y/2

	return Vector2(
		randf_range(min_x,max_x),
		randf_range(min_y,max_y)
	)

func spawn_enemy():
	var enemigo = enemy_scene.instantiate()
	add_child(enemigo)
	await get_tree().process_frame
	enemigo.global_position = obtener_posicion_spawn()
	enemigo.max_health += GameManager.nivel_actual*20
	enemigo.attack += GameManager.nivel_actual*3

func get_spawn():
	return $SpawnPlayer

func generar_piso():
	for enemigo in get_tree().get_nodes_in_group("enemigos"):
		enemigo.queue_free()
	combate_terminado = false
	label.visible = false
	
	var cantidad = 3 + GameManager.nivel_actual
	for i in range(cantidad):
		spawn_enemy()
	print("Piso:", GameManager.nivel_actual)

func entrar_al_piso():
	GameManager.nivel_actual += 1
	generar_piso()

func _process(delta):
	if combate_terminado:
		return
	
	if get_tree().get_nodes_in_group("enemigos").size() == 0:
		combate_terminado = true
		iniciar_countdown()




func iniciar_countdown():
	label.visible = true
	countdown = 3
	label.text = str(countdown)
	timer.start()

func volver_a_town():
	if teleportando:
		return
	teleportando = true
	fade.visible = true
	
	var tween = create_tween()
	tween.tween_property(fade, "modulate:a", 1.0, 0.2)
	await get_tree().create_timer(0.1).timeout
	
	player.global_position = destino.global_position
	camera.reset_smoothing()
	await tween.finished
	
	var tween2 = create_tween()
	tween2.tween_property(fade, "modulate:a", 0.0, 0.2)
	await tween2.finished
	
	fade.visible = false
	teleportando = false

func _on_timer_timeout() -> void:
	countdown -= 1
	if countdown > 0:
		label.text = str(countdown)
	else:
		label.visible = false
		timer.stop()
		
		volver_a_town()
