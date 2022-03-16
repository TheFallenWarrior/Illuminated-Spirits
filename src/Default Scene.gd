extends Spatial

# warning-ignore:return_value_discarded
func _ready():
	$UI/HealthBar.max_value = $Knight.MHP
	$UI/HealthBar.value = $Knight.HP
	$Knight.connect("health_changed", $UI, "update_health")
