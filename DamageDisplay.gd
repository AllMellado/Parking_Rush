extends Node2D

const FLASH_RATE = 0.05
const N_FLASHES = 4

onready var health_over = $HealthOver
onready var health_under = $HealthUnder
onready var update_tween = $UpdateTween
onready var flash_tween = $FlashTween

export (Color) var flash_color = Color.orangered

func _process(delta):
	global_rotation = 0

func _on_health_updated(health):
	health_over.value = health
	update_tween.interpolate_property(health_under, "value", health_under.value, health, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.4)
	update_tween.start()
	

func _flash_damage():
	for i in range(N_FLASHES * 2):
		var color = health_over.tint_progress if i % 2 == 1 else flash_color
		var time = FLASH_RATE * i + FLASH_RATE 
		flash_tween.interpolate_callback(health_over, time, "set", "tint_progress", color)
	flash_tween.start()
		
func _on_max_health_updated(max_health):
	health_over.max_value = max_health
	health_under.max_value = max_health
