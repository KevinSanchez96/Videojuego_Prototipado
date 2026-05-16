extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var fade = get_tree().current_scene.get_node("CanvasLayer/Control/ColorRect")
@onready var camera = get_viewport().get_camera_2d()
@onready var timer = $Timer
@onready var label = $Label

var scene1
var destino
var teleportando = false
var combate_terminado = false
var countdown

func _ready():

	scene1 = get_tree().current_scene.get_node("Scene1")
	destino = scene1.get_spawn()

func get_spawn():

	return $SpawnPlayer

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
