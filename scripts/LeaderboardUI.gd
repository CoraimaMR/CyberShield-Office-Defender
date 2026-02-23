extends CanvasLayer

# 1. load the row template (make sure the path is correct)
var row_scene = preload("res://scenes/ScoreRow.tscn")

@onready var score_list = %ScoreList
@onready var back_button = %BackButton
@onready var reset_button = %ResetButton

func _ready():
	display_scores() # show dates
	reset_button.visible = true

func display_scores():
	# clear the current list
	for child in score_list.get_children():
		child.queue_free()
	
	# iterate ALWAYS 10 positions
	for i in range(10):
		var row = row_scene.instantiate()
		score_list.add_child(row)
		# set the position number (i + 1 so it starts at 1)
		row.get_node("PosLabel").text = str(i + 1) + "."
		# check if there are actual data for this position
		if i < ScoreManager.high_scores.size():
			var entry = ScoreManager.high_scores[i]
			row.get_node("NameLabel").text = entry["name"]
			row.get_node("RankLabel").text = entry["rank"]
			row.get_node("ScoreLabel").text = str(entry["score"])
			# highlighted if it is the last player
			if entry["name"] == ScoreManager.last_player_name:
				var highlight_color = Color(1, 0.84, 0) # Dorado
				row.modulate = highlight_color
		else:
			# if there are NO data, we fill it with dashes or leave it empty
			row.get_node("NameLabel").text = "---"
			row.get_node("RankLabel").text = "---"
			row.get_node("ScoreLabel").text = "0"
			# lower the opacity of the empty rows so they are less noticeable
			row.modulate.a = 0.3

func _on_reset_button_pressed():
	ScoreManager.reset_scores()
	display_scores()

func _on_back_button_pressed() -> void:
	queue_free()
