extends StateMachine

func _ready():
	add_state("idle")
	add_state("drive")
	add_state("collide")
	add_state("parked")
	call_deferred("set_state",states.idle)
	
func _state_logic(delta):
	parent._handle_move_input()
	parent._apply_friction()
	parent._calculate_steering(delta)
	parent._apply_movement(delta)
	
func _get_transition(delta):
	match state:
		states.idle:
			if parent._check_is_colliding():
				parent.damage(20)
				return states.collide
			elif parent._is_parking() and !parent._is_active():
				parent.deactivate()
				print("parked")
				return states.parked
			elif parent.velocity.x != 0:
				return states.drive
		states.drive:
			if parent._check_is_colliding():
				parent.damage(20)
				return states.collide
			elif parent.velocity.x == 0:
				return states.idle
		states.collide:
			if !parent._check_is_colliding():
				if parent.velocity.x == 0:
					return states.idle
				else:
					return states.drive
		states.parked:
			if parent.velocity.x != 0:
				return states.drive
	return null
	
func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			parent.emit_signal("check_position", self)
			parent.label.text = "idle"
		states.drive:
			parent.label.text = "driving"
		states.collide:
			parent.label.text = "colliding"
		states.parked:
			parent.label.text = "parked"
	
func _exit_state(old_state, new_state):
	pass
