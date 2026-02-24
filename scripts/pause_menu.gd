extends Control # PAUSE MENU

# --- INITIALIZATION ---
func _ready():
	# Ensures this menu continues to run even when the rest of the game is frozen
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

# --- SIGNAL CALLBACKS ---
# Resumes the game and cleans up the pause overlay
func _on_pause_button_pressed() -> void:
	# Unfreeze the scene tree
	get_tree().paused = false
	
	# Make the main UI (HUD) visible again before closing
	var hub = get_parent().get_node_or_null("hub")
	if hub:
		hub.visible = true
	
	# Remove the pause menu from the scene
	queue_free()
