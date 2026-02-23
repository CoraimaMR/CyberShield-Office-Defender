extends Node # MENU
@onready var name_input = $NameInput

# Button 1: PREVIUS SCENE + RESET HUB
func _on_retry_button_pressed() -> void:
	Autoload.reset_hub()
	Autoload.previous_scene() # Go to previus scene

# Button 2: DESKTOP
func _on_desktop_button_pressed() -> void:
	Autoload.reset_hub()
	get_tree().call_deferred("change_scene_to_file", "res://scenes/Desktop.tscn") # Go to the desktop

# Button 3: LEVEL UPP
func _on_level_upp_button_pressed() -> void:
	get_tree().paused = false
	Autoload.previous_scene() # Go to previus scene

# Burron 4: SAVE PUNTUATION
func _on_save_button_pressed():
	var player_name = name_input.text
	
	if player_name.strip_edges() == "":
		player_name = "Player Unknow"
	
	# save dates dates to Autoload
	ScoreManager.add_new_score(player_name, Autoload.current_points, Autoload.current_rank)
	# visual effect on pressed
	$NameInput/SaveButton.disabled = true
	$NameInput.editable = false
	$NameInput/SaveButton.modulate = Color(0.5, 0.5, 0.5)
