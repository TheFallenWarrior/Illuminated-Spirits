extends Control

func update_health(hp, max_hp):
	$HealthBar.max_value = max_hp
	$HealthBar.value = hp

func _process(delta):
	$FPS.text = "FPS " + str(round(1.0/delta))
