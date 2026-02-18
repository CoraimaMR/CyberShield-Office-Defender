extends Node # AUTOLOAD

# Signals to notify the UI when data changes
signal points_updated(new_value)
signal lifes_updated(new_value)

var current_points: int = 0
var current_lifes: int = 3
var max_lifes: int = 3
var previous_scene_path: String = ""

# ----- SCENES -----

func save_scene(_path: String):
	previous_scene_path = get_tree().current_scene.scene_file_path

func previous_scene():
	if previous_scene_path != "":
		get_tree().change_scene_to_file(previous_scene_path)
	else:
		print("There is no saved previous scene")

# ----- POINTS -----

func add_points(points: int) -> void:
	current_points += points
	points_updated.emit(current_points) # Notify any active UI

func remove_points(points: int) -> void:
	current_points = current_points - points
	points_updated.emit(current_points)

# ----- LIFES -----

func add_lifes(lifes: int) -> void:
	current_lifes = min(max_lifes, current_lifes + lifes)
	lifes_updated.emit(current_lifes)

func remove_lifes(lifes: int) -> void:
	current_lifes = max(0, current_lifes - lifes)
	lifes_updated.emit(current_lifes)

# ----- RESET HUB -----

func reset_hub():
	current_points = 0
	current_lifes  = 3
