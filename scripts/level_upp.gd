extends Node2D # LEVEL UPP

# --- ONREADY NODES ---
@onready var window = $"popup window"
@onready var title_label = $"popup window/title"
@onready var description_label = $"popup window/description"
@onready var continue_btn = $Button

# --- INITIALIZATION ---
func _ready() -> void:
	# Show the transition window and disable the background button
	window.visible = true
	continue_btn.disabled = true
	
	# Set the title based on current level and rank
	title_label.text = "Level " + str(Autoload.current_level) + ". " + str(Autoload.current_rank)
	
	# Build the description dynamically based on the level reached
	var base_text = "CONGRATULATIONS, YOU'VE LEVELED UP! "
	
	match Autoload.current_level:
		2: description_label.text = base_text + "This new level will implement a time limit bar to complete each email."
		3: description_label.text = base_text + "The difficulty will now increase. BE CAREFUL!"
		_: description_label.text = base_text

# --- SIGNAL CALLBACKS ---
# Triggered when the user confirms the level up to return to gameplay
func _on_level_upp_button_pressed() -> void:
	get_tree().paused = false
	Autoload.previous_scene() # Returns to the gameplay scene stored in Autoload

# Triggered to hide the popup and enable the interaction button
func _on_close_button_pressed() -> void:
	window.visible = false
	continue_btn.disabled = false
