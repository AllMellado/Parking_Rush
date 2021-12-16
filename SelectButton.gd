extends TextureButton

signal button_pressed

func _input(event):
	if self.is_pressed():
		emit_signal("button_pressed", $Num.text.split(" ")[1][0])

