extends Area2D

@export var daño = 10
@export var daño_periodico = 0.25

var enemigos_dentro = []

func _ready() -> void:
	$TiempoVida.start()
	$"TiempoDaño".start()
	$AnimatedSprite2D.play()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemigos"):
		enemigos_dentro.append(body)

func _on_body_exited(body: Node2D) -> void:
	enemigos_dentro.erase(body)

func daño_pausado():
	for enemigos in enemigos_dentro:
		if is_instance_valid(enemigos):
			enemigos.take_damage(daño)

func _on_tiempo_vida_timeout() -> void:
	$AnimatedSprite2D.stop()
	queue_free()

func _on_tiempo_daño_timeout() -> void:
	daño_pausado()
