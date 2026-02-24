extends Node2D # LEVEL UPP

@onready var window = $"popup window"
@onready var title_label = $"popup window/title"
@onready var description_label = $"popup window/description"

func _ready() -> void:
	window.visible = true
	$Button.disabled = true
	title_label.text = "Level " + str(Autoload.current_level) + ". " + str(Autoload.current_rank) # TITLE WINDOW
	description_label.text = "CONGRATULATIONS, YOU'VE LEVELED UP! " # COMMON DESCRIPTION OF THE LEVELS
	match Autoload.current_level:
		2: description_label.text += "This new level will implement a time limit bar to complete each email."
		3: description_label.text += "The difficulty will now increase. BE CAREFUL!"

# Button 1: LEVEL UPP
func _on_level_upp_button_pressed() -> void:
	get_tree().paused = false
	Autoload.previous_scene() # Go to previus scene

# Button 2: CLOSE
func _on_close_button_pressed() -> void:
	window.visible = false
	$Button.disabled = false
