extends CanvasLayer # LEADERBOARD UI

# --- PRELOADS ---
# Load the row template for individual score entries
var row_scene = preload("res://scenes/ScoreRow.tscn")

# --- ONREADY NODES ---
@onready var score_list = %ScoreList
@onready var back_button = %BackButton
@onready var reset_button = %ResetButton

# --- INITIALIZATION ---
func _ready():
	# Populate the list with data upon opening
	display_scores()
	reset_button.visible = true

# --- SCORE DISPLAY LOGIC ---
# Clears the container and populates exactly 10 rows with player data or placeholders
func display_scores():
	# Clear existing children from the list container
	for child in score_list.get_children():
		child.queue_free()
	
	# Always iterate through 10 positions for a consistent UI
	for i in range(10):
		var row = row_scene.instantiate()
		score_list.add_child(row)
		
		# Set the rank number (starting from 1)
		row.get_node("PosLabel").text = str(i + 1) + "."
		
		# Check if there is actual data for this ranking position
		if i < ScoreManager.high_scores.size():
			var entry = ScoreManager.high_scores[i]
			row.get_node("NameLabel").text = entry["name"]
			row.get_node("RankLabel").text = entry["rank"]
			row.get_node("ScoreLabel").text = str(int(entry["score"]))
			
			# Highlight the row if it belongs to the current player
			if entry["name"] == ScoreManager.last_player_name:
				var highlight_color = Color(1, 0.84, 0) # Gold
				row.modulate = highlight_color
		else:
			# Fill empty positions with dashes as placeholders
			row.get_node("NameLabel").text = "---"
			row.get_node("RankLabel").text = "---"
			row.get_node("ScoreLabel").text = "0"
			
			# Dim the opacity of empty rows for better visual hierarchy
			row.modulate.a = 0.3

# --- SIGNAL CALLBACKS ---
# Wipes all data from the ScoreManager and refreshes the display
func _on_reset_button_pressed():
	ScoreManager.reset_scores()
	display_scores()

# Removes the leaderboard overlay and returns to the previous menu
func _on_back_button_pressed() -> void:
	queue_free()
