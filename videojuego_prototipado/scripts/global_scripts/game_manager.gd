extends Node

var nivel_actual : int

func nueva_partida():
	DeckManager.resetear()
	nivel_actual = 0
	print(nivel_actual)
