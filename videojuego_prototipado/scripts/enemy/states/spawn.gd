extends State

func enter():
	entity.get_node("Sprite2D").visible = true
	entity.get_node("CollisionShape2D").set_deferred("disabled",false)
	###animacion
##
#func finalice_animacion():
	#get_parent().change_state(get_parent().get_node("Chase"))
