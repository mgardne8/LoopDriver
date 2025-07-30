extends CharacterBody2D

var wheel_base = 70
var steering_angle = 15
var acceleration = 500

var steer_direction

func _physics_process(delta: float) -> void:
	get_input()
	calculate_steering(delta)
	move_and_slide()
	
func get_input():
	var turn = 0
	if Input.is_action_pressed("steer_right"):
		turn +=1
	if Input.is_action_pressed("steer_left"):
		turn -=1
	steer_direction = turn * deg_to_rad(steering_angle)
	velocity = Vector2.ZERO
	if Input.is_action_pressed("accelerate"):
		velocity = transform.x * acceleration

func calculate_steering(delta):
	var rear_wheel = position - transform.x * wheel_base/2
	var front_wheel = position + transform.x * wheel_base/2
	rear_wheel == velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta
	var new_heading = (front_wheel - rear_wheel).normalized()
	velocity = new_heading * velocity.length()
