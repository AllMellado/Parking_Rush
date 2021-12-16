extends PathFollow2D

onready var speed = 350

func _process(delta):
	set_offset(get_offset() + speed * delta)
