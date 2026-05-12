extends Control

var coins = 0
var textocoins = " : "

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/HBoxContainer/Label.text = " : " + str(coins)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func count_coin():
	coins += 1
	$CanvasLayer/HBoxContainer/Label.text = " : " + str(coins)
