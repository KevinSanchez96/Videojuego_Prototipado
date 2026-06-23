extends State

var timer := 0.0

func enter():
	entity.die = true
	entity.velocity = Vector2.ZERO
	if abs(entity.direccion_mirada.x) > abs(entity.direccion_mirada.y):
		if entity.direccion_mirada.x > 0:
			$"../../Sprite2D/AnimationPlayer".play("deadright")
		else:
			$"../../Sprite2D/AnimationPlayer".play("deadleft")
	else:
		if entity.direccion_mirada.y > 0:
			$"../../Sprite2D/AnimationPlayer".play("deadright")
		else:
			$"../../Sprite2D/AnimationPlayer".play("deadleft")
	
	mostrar_gameover()
	timer = 3.0


func update(delta):
	timer -= delta
	if timer <= 0.0:
		entity.queue_free()
		get_tree().change_scene_to_file("res://scenes/menu.tscn")

func mostrar_gameover():
	var panel = get_tree().get_first_node_in_group("gameover")
	var fondo = panel.get_node("ColorRect")
	var texto = panel.get_node("Label")
	var tween = create_tween()
	var camara = entity.get_node("Camera2D")
	
	texto.visible = true
	
	fondo.color.a = 0.0
	texto.modulate.a = 0.0
	texto.scale = Vector2(0.5,0.5)
	
	texto.pivot_offset = texto.size / 2
	
	tween.parallel().tween_property(fondo,"color:a",0.8,2.0)
	tween.parallel().tween_property(texto,"modulate:a",1.0,1.5)
	tween.parallel().tween_property(texto,"scale",Vector2(1.5,1.5),3.0)
	
	create_tween().tween_property(camara,"zoom",Vector2(3,3),3.0)
