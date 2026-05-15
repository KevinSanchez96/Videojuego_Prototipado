extends StaticBody2D

var player_cerca = false
var scene2
var destino

@onready var label = $Label

@onready var player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	label.visible = false
	scene2 = get_tree().current_scene.get_node("Scene2")
	destino = scene2.get_spawn()
	
func _process(delta: float) -> void:
	if player_cerca and Input.is_action_just_pressed("interact"):
		player.global_position = destino.global_position

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		label.visible = true
		player_cerca = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		label.visible = false
		player_cerca = false
