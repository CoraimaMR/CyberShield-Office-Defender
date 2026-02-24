extends Node # SCORE MANAGER (Autoload/Singleton)

# --- CONSTANTS ---
# The path where ranking data is permanently stored on the user's device
const SAVE_PATH = "user://highscore_ranking.save"

# Maximum number of entries allowed in the leaderboard
const MAX_SCORES: int = 10

# --- STATE VARIABLES ---
var last_player_name: String = ""
var high_scores: Array = [] # List of dictionaries: {"name": str, "score": int, "rank": str}

# --- INITIALIZATION ---
func _ready():
	# Load existing data if the save file exists
	if FileAccess.file_exists(SAVE_PATH):
		load_scores_from_file()
	else:
		high_scores = []

# --- FILE I/O OPERATIONS ---

# Writes the current ranking list to the disk in JSON format
func save_scores():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(high_scores) 
		file.store_string(json_string) 
		file.close()

# Reads the saved file and converts the JSON content back into a Godot Array
func load_scores_from_file():
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		file.close()
		
		var data = JSON.parse_string(content)
		if data is Array:
			high_scores = data

# --- DATA MANAGEMENT ---

# Adds a new entry, sorts the list, and enforces the table limit
func add_new_score(p_name: String, p_score: int, p_rank: String):
	# Update the last player name for UI highlighting
	last_player_name = p_name 
	
	# Create the new data entry
	var new_entry = {
		"name": p_name, 
		"score": p_score, 
		"rank": p_rank
	}
	
	high_scores.append(new_entry)
	
	# Sort the list based on points using a custom comparison function
	high_scores.sort_custom(sort_by_score)
	
	# Keep only the top entries defined by MAX_SCORES
	if high_scores.size() > MAX_SCORES:
		high_scores.resize(MAX_SCORES)
	
	# Update the permanent save file
	save_scores()

# Custom comparison logic: returns true if 'a' has a higher score than 'b'
func sort_by_score(a, b):
	return a["score"] > b["score"]

# Clears the ranking list and updates the save file
func reset_scores():
	high_scores = [] 
	save_scores()
