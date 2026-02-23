extends Node

# file where the information will be permanently saved
const SAVE_PATH = "user://highscore_ranking.save"

# limit of people in the table
const MAX_SCORES: int = 10

var last_player_name: String = ""
# list of dictionaries (Array of Dictionaries)
var high_scores: Array = []

func _ready():
	if FileAccess.file_exists(SAVE_PATH):
		load_scores_from_file()
	else:
		high_scores = []

# function to save the ranking to the disk
func save_scores():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var json_string = JSON.stringify(high_scores) # convert the Godot Array to a JSON formatted text string
	file.store_string(json_string) # save inside the file
	file.close()

# load the ranking from the disk
func load_scores_from_file():
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var content = file.get_as_text() # reads the file content and saves it into a text variable
	file.close()
	
	var data = JSON.parse_string(content) # converts the JSON text back into a format that Godot understands (an Array)
	if data is Array:
		high_scores = data

func add_new_score(p_name: String, p_score: int, p_rank: String):
	
	last_player_name = p_name # save the name before adding it
	var new_entry = {"name": p_name, "score": p_score, "rank": p_rank}
	high_scores.append(new_entry)
	# 3. OSORT: use a custom function to sort by points
	high_scores.sort_custom(sort_by_score)
	
	# 4. LIMIT: If there are now 11, delete the last one
	if high_scores.size() > MAX_SCORES:
		high_scores.resize(MAX_SCORES)
	
	save_scores()

# auxiliary function to compare two scores (necessary for sort_custom)
func sort_by_score(a, b):
	return a["score"] > b["score"]

func reset_scores():
	high_scores = [] # empty array
	save_scores()    # save the file
