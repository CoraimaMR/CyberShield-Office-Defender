extends Node # MENU

# Button 1: PREVIUS SCENE + RESET HUB
func _on_retry_button_pressed() -> void:
	Autoload.reset_hub()
	Autoload.previous_scene() # Go to previus scene

# Button 2: DESKTOP
func _on_desktop_button_pressed() -> void:
	Autoload.reset_hub()
	get_tree().call_deferred("change_scene_to_file", "res://scenes/Desktop.tscn") # Go to the desktop
