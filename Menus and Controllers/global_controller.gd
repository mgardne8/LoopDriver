extends Node


var total_passengers_waiting = 0
var Points = 0
var game_over : bool = false
@export var loss_threshold = 60

func _initiate():
	Points = 0
	game_over = false
	total_passengers_waiting = 0
	

func _physics_process(delta: float) -> void:
	if total_passengers_waiting > loss_threshold:
		game_over = true 
