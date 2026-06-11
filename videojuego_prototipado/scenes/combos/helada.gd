extends Area2D

@export var daño = 10
@export var tiempo_congelado = 5

var direccion = Vector2.ZERO

func _ready() -> void:
	$CollisionShape2D.rotation = direccion.angle()
	$TiempoVida.start()
	$AnimatedSprite2D.rotation = direccion.angle()
	$AnimatedSprite2D.play()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemigos"):
		body.aplicar_congelacion(tiempo_congelado, daño)

func _on_tiempo_vida_timeout() -> void:
	$AnimatedSprite2D.stop()
	queue_free()
