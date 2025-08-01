extends Node2D
class_name Bus_Stop

var passengers_waiting
var destination_number
var stop_popularity : float = 2 #lower number = more people showing up


func _ready() -> void:
	passengers_waiting = 0
	%NewPassengerArrival.wait_time = randf_range(stop_popularity,stop_popularity/2)
	%NewPassengerArrival.start()

func new_passenger():
	passengers_waiting += 1

func load_passengers():
	%NewPassengerArrival.stop()
	%PassengerBoardingTime.start()

func _on_passenger_boarding_time_timeout() -> void:
	passengers_waiting -= 1
	%PassengerBoardingTime.start()

func _physics_process(delta: float) -> void:
	$PassengerCountLabel.text = str(passengers_waiting)

func _on_busparking_body_entered(body: Node2D) -> void:
	if body.is_in_group("PlayerBus"):
		load_passengers()

func _on_busparking_body_exited(body: Node2D) -> void:
	%PassengerBoardingTime.stop()
	%NewPassengerArrival.wait_time = stop_popularity
	%NewPassengerArrival.start()

func _on_new_passenger_arrival_timeout() -> void:
	new_passenger()
	%NewPassengerArrival.wait_time = randf_range(stop_popularity,stop_popularity/2)
	%NewPassengerArrival.start()
