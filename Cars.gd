extends Node2D

onready var active = 0
onready var cars = get_children()
onready var nr_cars = get_child_count()

func _ready():
	get_node(cars[active].name).activate()

func _process(delta):
	if Input.is_action_just_released("space"):
		get_node(cars[active].name).deactivate()
		active += 1
		if active >= nr_cars:
			active = 0
		get_node(cars[active].name).activate()

func car_color(car_name):
	return get_node(car_name).get_color()

func parking(car_name, status):
	get_node(car_name).parking(status)

func check_damage(car_name):
	return get_node(car_name).check_damage()


func _on_Area2D_body_entered(car):
	get_node(car.name).entered_area()


func _on_Area2D_body_exited(car):
	get_node(car.name).exited_area()
