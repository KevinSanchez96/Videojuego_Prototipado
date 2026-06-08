extends Area2D

@export var daño = 10
@export var radio = 100
@export var velocidad_giro = 2.0

var creador
var angulo = 0.0

func _ready() -> void:
	$TiempoVida.start()
	
func _physics_process(delta: float) -> void:
	if is_instance_valid(creador) == false:
		queue_free()
		return
	angulo += velocidad_giro * delta
	global_position = creador.global_position + Vector2(cos(angulo), sin(angulo)) * radio

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemigos"):
		body.take_damage(daño)

func _on_tiempo_vida_timeout() -> void:
	queue_free()
