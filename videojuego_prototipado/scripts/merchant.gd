extends StaticBody2D

var player_cerca = false

@onready var label = $Label
@onready var shopUI = get_tree().current_scene.get_node("CanvasLayer/MainUI")

func _ready() -> void:
	label.visible = false

func _process(delta: float) -> void:
	if player_cerca and Input.is_action_just_pressed("interact"):
		shopUI.abrir()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_cerca = true
		label.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_cerca = false
		label.visible = false
