extends Node # MENU

# Button 1
func _on_button_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/main.tscn") # Go to the level

# Button 2
func _on_button_2_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/keys.tscn") # Go to the keyboard scene

# Button 3
func _on_button_3_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/Desktop.tscn") # Go to the desktop
