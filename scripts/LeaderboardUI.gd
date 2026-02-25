extends CanvasLayer # LEADERBOARD UI

# --- PRELOADS ---
# Load the row template for individual score entries
var row_scene = preload("res://scenes/ScoreRow.tscn")

# --- ONREADY NODES ---
@onready var score_list = %ScoreList
@onready var back_button = %BackButton
@onready var reset_button = %ResetButton
@onready var btn_email = $CenterContainer/PanelContainer/VBoxContainer/TabContainer/BtnEmail
@onready var btn_mobile = $CenterContainer/PanelContainer/VBoxContainer/TabContainer/BtnMobile

# --- STATE VARIABLES ---
var current_tab = "email" # Controls which table we are viewing

# --- INITIALIZATION ---
func _ready():
	# Populate the list with data upon opening
	display_scores()
	_update_tab_visuals()
	reset_button.visible = true

# --- SCORE DISPLAY LOGIC ---
# Clears the container and populates exactly 10 rows with player data or placeholders
func display_scores():
	# Clear existing children from the list container
	for child in score_list.get_children():
		child.queue_free()
	# Select data according to tab
	var scores_to_show = []
	if current_tab == "email":
		scores_to_show = ScoreManager.email_scores
	else:
		scores_to_show = ScoreManager.mobile_scores
	# Always iterate through 10 positions for a consistent UI
	for i in range(10):
		var row = row_scene.instantiate()
		score_list.add_child(row)
		
		# Set the rank number (starting from 1)
		row.get_node("PosLabel").text = str(i + 1) + "."
		
		# Check if there is actual data for this ranking position
		if i < scores_to_show.size():
			var entry = scores_to_show[i]
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
func _on_btn_email_pressed():
	current_tab = "email"
	display_scores()
	_update_tab_visuals()
	print("He pulsado el botón de email")
	
func _on_btn_mobile_pressed():
	current_tab = "mobile"
	display_scores()
	_update_tab_visuals()
	print("He pulsado el botón de móvil")
	
func _update_tab_visuals():
	# Visual effect: darkens the button that is not active
	if btn_email and btn_mobile:
		if current_tab == "email":
			# Email active: lighting. Mobile: darkness.
			btn_email.modulate = Color(1, 1, 1, 1) 
			btn_mobile.modulate = Color(0.5, 0.5, 0.5, 1) 
		else:
			# Mobile active: lighting. Email: darkness.
			btn_email.modulate = Color(0.5, 0.5, 0.5, 1)
			btn_mobile.modulate = Color(1, 1, 1, 1)

# Returns to the main menu or clears the content of the current tab
func _on_reset_button_pressed():
	ScoreManager.reset_scores(current_tab)
	display_scores()

func _on_back_button_pressed() -> void:
	queue_free()
