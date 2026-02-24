extends Node # AUTOLOAD

# --- SIGNALS ---
# Used to notify the UI or other nodes when data changes
signal points_updated(new_value)
signal lifes_updated(new_value)
signal level_up(new_level, new_rank)

# --- STATE VARIABLES ---
var current_points: int = 0
var current_lifes: int = 3
var max_lifes: int = 3
var previous_scene_path: String = ""
var tutorial_done: bool = false

# --- PROGRESS VARIABLES ---
var LEVEL_FINAL = 4
var current_level: int = 1
var current_rank: String = "Intern"
var solved_in_this_level: int = 0

# --- SCORE MANAGEMENT ---
# Adds points and notifies listeners
func add_points(points: int) -> void:
	current_points += points
	points_updated.emit(current_points)

# Deducts points and notifies listeners
func remove_points(points: int) -> void:
	current_points = current_points - points
	points_updated.emit(current_points)

# --- LIFE MANAGEMENT ---
# Adds lives but keeps them within the max limit
func add_lifes(lifes: int) -> void:
	current_lifes = min(max_lifes, current_lifes + lifes)
	lifes_updated.emit(current_lifes)

# Removes lives but ensures they don't go below zero
func remove_lifes(lifes: int) -> void:
	current_lifes = max(0, current_lifes - lifes)
	lifes_updated.emit(current_lifes)

# --- LEVEL & RANK PROGRESSION ---
# Increments progress and triggers level-up check every 10 solves
func register_solved():
	solved_in_this_level += 1
	if solved_in_this_level >= 10:
		check_level_up()

# Handles level increments, rank updates, and scene transitions
func check_level_up():
	current_level += 1
	solved_in_this_level = 0
	
	# Rank assignment logic based on level
	if current_level == 2:
		current_rank = "Junior Technician"
	elif current_level == 3:
		current_rank = "Security Expert"
	else:
		current_rank = "The Boss"

	print("¡NEW LEVEL!: ", current_level, " Range: ", current_rank)
	level_up.emit(current_level, current_rank)
	
	# Scene transition logic
	if current_level < LEVEL_FINAL:
		Autoload.save_scene() 
		get_tree().call_deferred("change_scene_to_file", "res://scenes/level_upp.tscn")
	else:
		Autoload.save_scene() 
		get_tree().call_deferred("change_scene_to_file", "res://scenes/win_menu.tscn")

# Returns the time limit based on the current level difficulty
func get_time_for_level() -> float:
	if current_level == 2:
		return 20.0 # level 2
	elif current_level >= 3:
		return 12.0  # level 3
	return 9999.0    # level 1

# --- SCENE NAVIGATION ---
# Stores the current scene path before switching
func save_scene():
	if get_tree().current_scene:
		previous_scene_path = get_tree().current_scene.scene_file_path

# Changes the scene back to the previously saved path
func previous_scene():
	if previous_scene_path != "":
		get_tree().change_scene_to_file(previous_scene_path)

# --- RESET LOGIC ---
# Resets all global variables to their default values
func reset_hub():
	current_points = 0
	current_lifes = 3
	current_level = 1
	current_rank = "Intern"
	solved_in_this_level = 0
