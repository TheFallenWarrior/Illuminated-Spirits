extends Control

func update_health(hp, max_hp):
	$HealthBar.max_value = max_hp
	$HealthBar.value = hp

func update_stamina(stamina, max_stamina):
	$StaminaBar.max_value = max_stamina
	$StaminaBar.value = stamina

func update_xp_level(xp, level):
	$SoulsCount.text = str(xp)
	$Level.text = str(level)

func update_estus(estus):
	$EstusCount.text = str(estus)

func _process(delta):
	$FPS.text = "FPS " + str(round(1.0/delta))
