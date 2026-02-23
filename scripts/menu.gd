extends Node # MENU

@onready var name_input = find_child("NameInput", true, false)
@onready var save_button = find_child("SaveButton", true, false)

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

# Button 4: SAVED GAMEOVER
func _on_save_button_pressed():
	if name_input == null or save_button == null:
		# Si esto sale en consola, es que los nombres en el árbol no son NameInput o SaveButton
		print("Error: No se encuentran los nodos.")
		return
	var player_name = name_input.text
	
	if player_name.strip_edges() == "":
		player_name = "Player Unknow"
	
	# save dates dates to Autoload
	ScoreManager.add_new_score(player_name, Autoload.current_points, Autoload.current_rank)
	ScoreManager.save_scores()
	# visual effect on pressed
	name_input.editable = false
	save_button.disabled = true
	save_button.modulate = Color(0.4, 0.4, 0.4)
