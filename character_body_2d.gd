extends CharacterBody2D

var wheel_base = 70
var steering_angle = 5
var engine_power = 1200
var friction = -0.5
var drag = -0.001
var braking = -450
var max_speed_rev = 250
var slip_speed = 400
var traction_fast = 0.1
var traction_base : float = 0.7
var traction :float = traction_base
var handbreak_traction = 0.001
var handbrake_strength = -100
var handbraking = false

var acceleration = Vector2.ZERO
var steer_direction

func _physics_process(delta: float) -> void:
	acceleration = Vector2.ZERO
	handbraking = false
	traction = lerp(traction,traction_base,0.08*delta)
	steering_angle = 8
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
	if Input.is_action_pressed("handbrake"):
		handbraking = true
		steering_angle = 20
		traction = handbreak_traction
	if Input.is_action_just_released("handbrake"):
		%RecoverTraction.start()
	steer_direction = turn * deg_to_rad(steering_angle)
	if Input.is_action_pressed("accelerate") and not handbraking:
		acceleration = transform.x * engine_power
	if Input.is_action_pressed("reverse"):
		acceleration = transform.x * braking
		
	
		
func calculate_steering(delta):
	var rear_wheel = position - transform.x * wheel_base/2
	var front_wheel = position + transform.x * wheel_base/2
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta
	var new_heading = (front_wheel - rear_wheel).normalized()
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = velocity.lerp(new_heading * velocity.length(),traction)
	if d < 0 :
		velocity = -new_heading * min(velocity.length(), max_speed_rev)

	rotation = new_heading.angle()
	


func _on_recover_traction_timeout() -> void:
	traction = traction_base
