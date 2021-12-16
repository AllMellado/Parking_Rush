extends KinematicBody2D

var maxspeed = 400
var speed = 0
var acceleration = 100
var move_direction
var moving = false
var destination = Vector2()
var moviment = Vector2()

var state_machine
var target = Vector2()
var velocity = Vector2()

func _unhandled_input(event):
	if event.is_action_pressed("click"):
		moving = true
		destination = get_global_mouse_position()
	
func _process(delta):
	AnimationLoop()

func _physics_process(delta):
	MovimentLoop(delta)

func MovimentLoop(delta):
	if moving == false:
		speed = 0
	else:
		speed = 100
		if speed > maxspeed:
			speed = maxspeed
	moviment = position.direction_to(destination) * speed
	move_direction = rad2deg(destination.angle_to_point(position))
	
	if position.distance_to(destination) > 5:
		moviment = move_and_slide(moviment)
	else:
		moving = false
		
func AnimationLoop():
	var anim_direction = "Right"
	var anim_mode = "Idle"
	var animation
	#print(move_direction)
	if move_direction >= -60 and move_direction <= 60:
		anim_direction = "Right"
	elif move_direction <= -60 and move_direction > -120:
		anim_direction = "Up"
	elif move_direction > 120 or move_direction <= -120:
		anim_direction = "Left"
	elif move_direction < 120 and move_direction > 60:
		anim_direction = "Down"  
	
	if moving == true:
		anim_mode = "Walk"
	else:
		anim_mode = "Idle"
	animation = anim_mode + "_" + anim_direction
	#print(animation)
	get_node("AnimationPlayer").play(animation)	
	



