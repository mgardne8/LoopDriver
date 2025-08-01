extends Node2D
class_name Bus_Stop

var passengers_waiting
@export var stop_number : int = 0
@export var stop_popularity : float = 10 #lower number = more people showing up
var player_Bus : CharacterBody2D


func _ready() -> void:
	player_Bus = get_tree().get_first_node_in_group("PlayerBus")
	passengers_waiting = 0
	%NewPassengerArrival.wait_time = randf_range(stop_popularity,stop_popularity/2)
	%NewPassengerArrival.start()

func new_passenger():
	passengers_waiting += 1
	GlobalController.total_passengers_waiting += 1

func load_passengers():
	%NewPassengerArrival.stop()
	%PassengerBoardingTime.start()

func _on_passenger_boarding_time_timeout() -> void:
	var passenger_destination = randi_range(0,5)
	if passenger_destination == stop_number:
		passenger_destination +=1
		if passenger_destination > 5:
			passenger_destination = 0
	passengers_waiting -= 1
	GlobalController.total_passengers_waiting -= 1
	player_Bus.passenger_boarding(passenger_destination)
	if passengers_waiting > 0:
		load_passengers()

func unload_passenger():
	%NewPassengerArrival.stop()
	%PassengerLeavingTime.start()

func _on_passenger_leaving_time_timeout() -> void:
	if player_Bus.passenger_destination[stop_number] > 0:
		player_Bus.passenger_destination[stop_number] -= 1
		GlobalController.Points += 1
		unload_passenger()
		##TODO give feedback for unloading

func _physics_process(delta: float) -> void:
	$PassengerCountLabel.text = str(passengers_waiting)

func _on_busparking_body_entered(body: Node2D) -> void:
	if player_Bus.next_stop == stop_number:
			player_Bus.set_next_stop()
	if body.is_in_group("PlayerBus") and passengers_waiting > 0:
		load_passengers()

		if player_Bus.passenger_destination[stop_number] > 0:
			unload_passenger()
	

func _on_busparking_body_exited(body: Node2D) -> void:
	%PassengerBoardingTime.stop()
	%NewPassengerArrival.wait_time = stop_popularity
	%NewPassengerArrival.start()

func _on_new_passenger_arrival_timeout() -> void:
	new_passenger()
	%NewPassengerArrival.wait_time = randf_range(stop_popularity,stop_popularity/2)
	%NewPassengerArrival.start()
