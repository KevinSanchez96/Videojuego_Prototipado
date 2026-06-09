extends Area2D

@export var daño = 15
@export var velocidad = 400

var direccion = Vector2.ZERO

func _ready() -> void:
	$CollisionShape2D.rotation = direccion.angle()
	$TiempoTorrente.start()

func _physics_process(delta: float) -> void:
	global_position += direccion * velocidad * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemigos"):
		body.take_damage(daño)

func _on_tiempo_torrente_timeout() -> void:
	queue_free()
