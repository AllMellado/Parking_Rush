extends Node2D

onready var spot_color = $VagaCor

func _ready():
	var spot_array = self.name.split("_",1)
	set_color(spot_array[0])

func set_color(color):
	match color:
		"red": spot_color.modulate = Color.red
		"green": spot_color.modulate = Color.green
		"yellow": spot_color.modulate = Color.yellow
		"blue": spot_color.modulate = Color.blue
	
func get_color():
	return spot_color.modulate
