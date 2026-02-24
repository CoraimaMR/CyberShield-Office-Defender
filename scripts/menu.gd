extends Node # MENU SYSTEM

# --- ONREADY NODES ---
@onready var name_input = find_child("NameInput", true, false)
@onready var save_button = find_child("SaveButton", true, false)

# --- BUTTON INTERACTIONS ---

# Retry Logic: Resets the game state and returns to the previous level
func _on_retry_button_pressed() -> void:
	Autoload.reset_hub()
	Autoload.previous_scene()

# Navigation Logic: Resets the state and returns to the main Desktop menu
func _on_desktop_button_pressed() -> void:
	Autoload.reset_hub()
	get_tree().call_deferred("change_scene_to_file", "res://scenes/Desktop.tscn")

# Progression Logic: Resumes the game and proceeds after a level-up
func _on_level_upp_button_pressed() -> void:
	get_tree().paused = false
	Autoload.previous_scene()

# Data Persistence Logic: Saves the player's final score and rank to the Leaderboard
func _on_save_button_pressed():
	var player_name = name_input.text
	
	# Default name if the input field is empty
	if player_name.strip_edges() == "":
		player_name = "Unknown Player"
	
	# Send current session data to the ScoreManager
	ScoreManager.add_new_score(player_name, Autoload.current_points, Autoload.current_rank)
	ScoreManager.save_scores()
	
	# Visual feedback: Lock the input and dim the button after saving
	name_input.editable = false
	save_button.disabled = true
	save_button.modulate = Color(0.4, 0.4, 0.4)
