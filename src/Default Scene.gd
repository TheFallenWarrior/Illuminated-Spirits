extends Spatial

func _ready():
	$UI.update_health($Knight.hp, $Knight.mhp)
	$UI.update_stamina($Knight.stamina, $Knight.mstamina)
	$UI.update_xp_level($Knight.xp, $Knight.level)
	$UI.update_estus($Knight.estus)
# warning-ignore:return_value_discarded
	$Knight.connect("health_changed", $UI, "update_health")
# warning-ignore:return_value_discarded
	$Knight.connect("stamina_changed", $UI, "update_stamina")
# warning-ignore:return_value_discarded
	$Knight.connect("estus_qty_changed", $UI, "update_estus")
# warning-ignore:return_value_discarded
	$Knight.connect("xp_level_changed", $UI, "update_xp_level")
# warning-ignore:return_value_discarded
	for i in $Enemies.get_child_count():
		$Enemies.get_child(i).connect("enemy_killed", $Knight, "enemy_killed")
