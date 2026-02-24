extends Control # PAUSE MENU

func _ready():
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

# Button: PAUSE
func _on_pause_button_pressed() -> void:
	get_tree().paused = false
	get_parent().get_node("hub").visible = true
	queue_free()
