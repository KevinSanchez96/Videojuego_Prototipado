extends State

func update(delta):
	var enemy = get_parent().get_parent() # necesito referencia del enemy para poder hacer el siguiente if
	$"../../Sprite2D/AnimationPlayer".play("spawn")
	$"../../Sprite2D/AnimationPlayer".seek(0.0, true)
