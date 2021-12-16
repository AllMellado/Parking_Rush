extends PathFollow2D

onready var speed = 200

func _process(delta):
	set_offset(get_offset() + speed * delta)

