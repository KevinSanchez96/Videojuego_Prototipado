extends Area2D

@export var daño = 5
@export var tiempo_quemadura = 3

func _ready() -> void:
	$TiempoVida.start()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemigos"):
		body.aplicar_quemadura(tiempo_quemadura, daño)

func _on_tiempo_vida_timeout() -> void:
	queue_free()
