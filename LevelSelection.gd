extends Control

func _ready():
	for button in get_tree().get_nodes_in_group("LevelSelect"):
		button.connect("button_pressed", self, "_on_button_pressed")


func _on_button_pressed(levelNum):
	SceneChanger.change_scene("res://Level"+levelNum+".tscn", 'Fade')



