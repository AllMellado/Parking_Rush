extends Node2D

func spot_color(spot_name):
	return get_node(spot_name).get_color()
