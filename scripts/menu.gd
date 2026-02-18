extends Node # MENU

@onready var label_points = $points/point

func _ready() -> void:
	label_points.text = str(Autoload.current_points)

# Button 1: RETRY
func _on_button_pressed() -> void:
	Autoload.reset_hub()
	Autoload.previous_scene() # Go to previus scene

# Button 2: KEYS
func _on_button_2_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/keys.tscn") # Go to the keyboard scene

# Button 3: DESKTOP
func _on_button_3_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/Desktop.tscn") # Go to the desktop
