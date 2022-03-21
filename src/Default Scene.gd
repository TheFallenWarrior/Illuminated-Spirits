extends Spatial

func _ready():
	$UI.update_health($Knight.HP, $Knight.MHP)
	$UI.update_stamina($Knight.stamina, $Knight.Mstamina)
	$UI.update_estus($Knight.estus)
# warning-ignore:return_value_discarded
	$Knight.connect("health_changed", $UI, "update_health")
# warning-ignore:return_value_discarded
	$Knight.connect("stamina_changed", $UI, "update_stamina")
# warning-ignore:return_value_discarded
	$Knight.connect("estus_qty_changed", $UI, "update_estus")
