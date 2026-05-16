extends StaticBody2D

var player_cerca = false
var scene2
var destino

@onready var label = $Label
@onready var player = get_tree().get_first_node_in_group("player")
@onready var fade = get_tree().current_scene.get_node("CanvasLayer/Control/ColorRect")
@onready var camara = get_viewport().get_camera_2d()
var teleportando = false

func _ready() -> void:
	label.visible = false
	scene2 = get_tree().current_scene.get_node("Scene2")
	destino = scene2.get_spawn()

func _process(delta: float) -> void:
	if player_cerca and !teleportando and Input.is_action_just_pressed("interact"):
		teleport()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		label.visible = true
		player_cerca = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		label.visible = false
		player_cerca = false

func teleport():
	teleportando = true
	fade.visible = true
	var tween = create_tween()
	tween.tween_property(fade, "modulate:a", 1.0, 0.2)
	await get_tree().create_timer(0.1).timeout
	player.global_position = destino.global_position
	camara.reset_smoothing()
	await tween.finished
	var tween2 = create_tween()
	tween2.tween_property(fade, "modulate:a", 0.0, 0.2)
	await tween2.finished
	fade.visible = false
	teleportando = false
