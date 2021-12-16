extends PathFollow2D

onready var speed = 120

func _process(delta):
	set_offset(get_offset() + speed * delta)
