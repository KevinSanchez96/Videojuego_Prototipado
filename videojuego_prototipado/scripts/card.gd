extends TextureRect

var sostener = false
var offset = Vector2.ZERO

var zona_actual
var posicion_valida

@onready var hand = $"../Hand"
@onready var deck = $"../Deck"


func _ready():

	zona_actual = hand
	posicion_valida = global_position


func _gui_input(event):

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				sostener = true
				offset = global_position - get_global_mouse_position()
			else:
				sostener = false
				if get_global_rect().intersects(deck.get_global_rect()):
					zona_actual = deck
					posicion_valida = global_position
				elif get_global_rect().intersects(hand.get_global_rect()):
					zona_actual = hand
					posicion_valida = global_position
				else:
					global_position = posicion_valida

func _process(delta):
	if sostener:
		global_position = get_global_mouse_position() + offset
