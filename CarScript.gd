extends KinematicBody2D

signal health_updated(health)
signal broken()
signal check_position(this_car)

var active = 0
var parking = 0
var entered = 0

var wheel_base = 10  
var steering_angle = 16  
var engine_power = 400
var friction = -2
var drag = -0.1
var breaking = -362
var max_speed_reverse = 150

var splip_speed = 200
var traction_fast = 0.1
var traction_slow = 0.4

var acceleration = Vector2.ZERO
var velocity = Vector2.ZERO
var steer_direction = 0

export (float) var max_health = 100
onready var health = max_health setget _set_health

onready var iFrames = $IFrames
onready var effects_anim = $EffectsAnim
onready var lights = $CarBody/Ligths
onready var label = $HealthDisplay/Label
onready var shape = $CollisionShape2D

export(Color) var car_color = Color.black

func _ready():
	for child in get_children():
		if child is Sprite:
			set_color(child.name)
	self.connect("health_updated",$HealthDisplay,"_on_health_updated")

	
func set_color(color):
	match color:
		"red": car_color = Color.red
		"green": car_color = Color.green
		"yellow": car_color = Color.yellow
		"blue": car_color = Color.blue

func get_color():
	return car_color
	
func _apply_movement(delta):
	velocity += acceleration * delta
	velocity = move_and_slide(velocity)
	
	move_and_slide(velocity, Vector2(0, 0), false, 4, PI/4, false)

func _apply_friction():
	if velocity.length() < 6:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction
	var drag_force = velocity * velocity.length() * drag
	acceleration += friction_force + drag_force


func _handle_move_input():
	acceleration = Vector2.ZERO
	if active:
		var turn = 0
		if Input.is_action_pressed("right"):
			turn += 1
		if Input.is_action_pressed("left"):
			turn -= 1
		steer_direction = turn * deg2rad(steering_angle)
		if Input.is_action_pressed("up"):
			acceleration = transform.x * engine_power 
		if Input.is_action_pressed("down"):
			acceleration = transform.x * breaking
			

func _calculate_steering(delta):
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta
	
	var new_heading = (front_wheel - rear_wheel).normalized()
	var traction = traction_slow
	
	if velocity.length() > splip_speed:
		traction = traction_fast
	
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = velocity.linear_interpolate(new_heading * velocity.length(), traction)
	else:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	rotation = new_heading.angle()

func _check_is_colliding():
	if get_slide_count() or entered:
		return true
	for raycast in $CollideRaycasts.get_children():
		if raycast.is_colliding():
			return true
	return false

func damage(amount):
	if iFrames.is_stopped():
		iFrames.start()
		_set_health(health - amount)
		effects_anim.play("damage")
		effects_anim.queue("flash")

func check_damage():
	return health

func broke():
	pass
	
func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		emit_signal("health_updated", health)
		if health <= 0:
			broke()
			emit_signal("broken")

func parking(status):
	parking = status

func _is_parking():
	return parking
	
func activate():
	active = 1
	lights.visible = true

func deactivate():
	active = 0 
	lights.visible = false

func _is_active():
	return active	

func _on_IFrames_timeout():
	effects_anim.play("rest")


func entered_area():
	friction = -15
	entered = 1


func exited_area():
	friction = -2
	entered = 0
