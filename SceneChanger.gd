extends CanvasLayer

onready var anima = $Control/AnimationPlayer
var scene : String

func change_scene(new_scene, anim):
	scene = new_scene
	anima.play(anim)

func _new_scene():
	get_tree().change_scene(scene)
