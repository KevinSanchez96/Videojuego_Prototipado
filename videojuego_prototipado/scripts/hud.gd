extends Control

@onready var coins_label = $CoinsUI/Coins_Label

func actualizar_coins(cantidad):
	coins_label.text = str(cantidad)
