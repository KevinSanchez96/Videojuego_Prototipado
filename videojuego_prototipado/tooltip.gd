extends PanelContainer

const OFFSET: Vector2 = Vector2.ONE * 20.0
var opacity_tween: Tween = null
@onready var labeltipo = $MarginContainer/Tipo
@onready var labelelemento = $MarginContainer/Elemento

func _ready() -> void:
	hide()

func _input(event: InputEvent) -> void:
	if visible and event is InputEventMouseMotion:
		global_position = get_global_mouse_position() + OFFSET

func toggle(on: bool):
	if on:
		var card = get_parent()
		
		labeltipo.text = "Ataque: " + card.get_tipo_carta()
		labelelemento.text = "Elemento: " + card.get_elemento()
		show()
		modulate.a = 0.0
		tween_opacity(1.0)
	else:
		modulate.a = 1.0
		var tween = tween_opacity(0.0)
		if tween:
			await tween.finished
		hide()
func tween_opacity(to:float):
	if !is_inside_tree():
		return null
	if opacity_tween: opacity_tween.kill()
	opacity_tween = create_tween()
	opacity_tween.tween_property(self, 'modulate:a',to,0.3)
	return opacity_tween
#func set_card_data(tipo_ataque: String, elemento: String):
	#labeltipo.text = "Ataque: " + tipo_ataque
	#labelelemento.text = "Elemento: " + elemento
