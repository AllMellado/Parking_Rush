extends Node2D

var cars = null
var cars_node = null
var spots = null
var spots_node = null
var parked_cars = []

func _ready():
	cars = $Cars.get_children()
	cars_node = get_node($Cars.name)
	
	for car in cars:
		parked_cars.append(0)
		cars_node.get_node(car.name).connect("check_position", self, "_on_check_position")
	
	spots = $Spots.get_children()
	
	spots_node = get_node($Spots.name)

func _process(delta):
	if Input.is_action_just_released("esc") and !$GUI/LevelComplete.visible:
		$GUI/PauseMenu.visible = !$GUI/PauseMenu.visible
		

func _on_check_position(car_stuff):
	var index = 0
	for car in cars:
		for spot in spots:
			if( car.position.distance_to(spot.position) < 5
				and cars_node.car_color(car.name) == spots_node.spot_color(spot.name)):
				cars_node.parking(car.name,1)
				parked_cars[index] = 1
				check_end_condition()
				break
			else:
				cars_node.parking(car.name,0)
				parked_cars[index] = 0
		index += 1

func check_end_condition():
	if !parked_cars.has(0):
		var damage_sum = 0
		for car in cars:
			damage_sum += cars_node.check_damage(car.name)
		$GUI/LevelComplete/VBoxContainer/Points.text = str(floor(damage_sum/cars.size())) + " / 100 POINTS"
		$GUI/LevelComplete.visible = true


func _on_Menu_pressed():
	$GUI/LevelComplete.visible = false
	$GUI/PauseMenu.visible = false
	SceneChanger.change_scene('res://TitleScreen.tscn', 'Fade')


func _on_RetryLevel_pressed():
	$GUI/LevelComplete.visible = false
	$GUI/PauseMenu.visible = false
	SceneChanger.change_scene('res://'+self.name+'.tscn', 'Fade')


func _on_NextLevel_pressed():
	$GUI/LevelComplete.visible = false
	$GUI/PauseMenu.visible = false
	var nextLevel = int(self.name.split("Level")[1])+1
	SceneChanger.change_scene('res://Level'+str(nextLevel)+'.tscn', 'Fade')
