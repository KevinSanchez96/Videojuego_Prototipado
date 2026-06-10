extends Control
func _ready() -> void:
	$AnimatedSprite2D.play()
func _process(delta: float) -> void:
	pass

func _on_jugar_pressed() -> void:
	GameManager.nueva_partida()
	$AnimatedSprite2D.stop()
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_salir_button_up() -> void:
	get_tree().quit()
