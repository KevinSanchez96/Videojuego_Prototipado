extends HBoxContainer

func _ready() -> void:#Que se tome a sí mismo como Deck para la DeckManager xd
	DeckManager.set_deck(self)
