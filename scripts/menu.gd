extends Node # MENU

# Button 1
func _on_button_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/map01.tscn") # Go to the first map

# Button 2
func _on_button_2_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/keys.tscn") # Go to the keyboard scene
