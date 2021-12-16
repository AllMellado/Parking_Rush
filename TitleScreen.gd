extends Control

func _on_NewGame_pressed():
	SceneChanger.change_scene('res://Level1.tscn','Fade')


func _on_SelectLevel_pressed():
	SceneChanger.change_scene('res://LevelSelection.tscn','Fade')
