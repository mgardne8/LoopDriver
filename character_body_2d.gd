extends CharacterBody2D

var wheel_base = 70
var steering_angle = 15
var engine_power = 900
var friction = -0.5
var drag = -0.001
var slip_speed = 400
var traction_fast = 0.1
var traction_slow = 1

var acceleration = Vector2.ZERO
var steer_direction

func _physics_process(delta: float) -> void:
	acceleration = Vector2.ZERO
	get_input()
	apply_friction()
	calculate_steering(delta)
	velocity += acceleration * delta
	move_and_slide()
	
func apply_friction():
	if velocity.length() < 5:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction
	var drag_force = velocity * velocity.length() *drag
	acceleration += friction_force + drag_force
func get_input():
	var turn = 0
	if Input.is_action_pressed("steer_right"):
		turn +=1
		
	if Input.is_action_pressed("steer_left"):
		turn -=1
		
	steer_direction = turn * deg_to_rad(steering_angle)
	if Input.is_action_pressed("accelerate"):
		acceleration = self.transform.x * engine_power

func calculate_steering(delta):
	var rear_wheel = position - transform.x * wheel_base/2
	var front_wheel = position + transform.x * wheel_base/2
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta
	var new_heading = (front_wheel - rear_wheel).normalized()
	velocity = new_heading * velocity.length()
	rotation = new_heading.angle()
	
