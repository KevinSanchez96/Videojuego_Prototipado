extends Panel

var ocupado = false

func _ready() -> void:
	if get_child_count() > 0:
		ocupado = true
