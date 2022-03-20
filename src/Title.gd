extends Control

func loadlevel():
	print("Level loaded or something idk")
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://src/Level 1.tscn")

# warning-ignore:return_value_discarded
func _on_TextureButton_pressed():
	print("?????")
	#$TextureButton/Label.text = "Loading"
	#$Logo.visible = false
	$TextureButton.visible = false
	$VersionNumber.text = "Loading"
	loadlevel()
