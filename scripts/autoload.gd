extends Node # AUTOLOAD

# Signals to notify the UI when data changes
signal points_updated(new_value)
signal lifes_updated(new_value)
signal level_up(new_level, new_rank) # signal to notify/emit when the player ascends or levels up

var current_points: int = 0
var current_lifes: int = 3
var max_lifes: int = 3
var previous_scene_path: String = ""

# ----- PROGRESS -----

var current_level: int = 1
var current_rank: String = "Intern"
var emails_solved_in_this_level: int = 0

# ----- SCENES -----

func save_scene():
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
	# increment the email counter every time points are added for a correct answer/match
	emails_solved_in_this_level += 1
	check_level_up()

func remove_points(points: int) -> void:
	current_points = current_points - points
	points_updated.emit(current_points)

# ----- LEVEL PROGRESS -----

func check_level_up():
	if emails_solved_in_this_level >= 10:
		upgrade_level()

func upgrade_level():
	current_level += 1
	emails_solved_in_this_level = 0
	if current_level == 2:
		current_rank = "Junior Technician"
	elif current_level == 3:
		current_rank = "Security Expert"
	else:
		current_rank = "The Boss"

	level_up.emit(current_level, current_rank) # notify the game about the promotion
	print("PROMOTION! Level:", current_level, " Rank:", current_rank)
	
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
	current_lifes = 3
	current_level = 1
	current_rank = "Intern"
	emails_solved_in_this_level = 0
