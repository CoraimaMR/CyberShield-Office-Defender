extends Control # MESSAGES LEVEL

# --- CONSTANTS ---
const PUT_POINTS := 5
const REMOVE_POINTS := 10

# --- DATA & STATE ---
@export var message_list: Array[Resource] = [] # Stores MessageResource (.tres) files
var current_index: int = 0

# --- ONREADY NODES: UI ---
@onready var title_label = %"Label-title"
@onready var description_label = %"Label-description"
@onready var date_label = %"Label-date"

# --- ONREADY NODES: POPUP & FEEDBACK ---
@onready var solution = %solution
@onready var title_solution = %"Label-title-solution"
@onready var tip_label = %"Label-tip"
@onready var correct_sound = $correct
@onready var incorrect_sound = $incorrect

# --- NODES: EXTERNAL ---
@onready var hub_scene = %hub

# --- TIMER VARIABLES ---
var time_limit: float = 10.0
var time_left: float = 10.0
var timer_active: bool = false

# --- INITIALIZATION ---
func _ready():
	Autoload.save_scene() 
	load_messages_from_folder()
	solution.visible = false
	
	if message_list.size() > 0:
		display_message()
	else:
		description_label.text = "No messages found."

# --- MAIN LOOP ---
func _process(delta: float) -> void:
	# Handle Pause Input
	if Input.is_action_just_pressed("ui_cancel"):
		if not get_tree().paused:
			var pause_scene = load("res://scenes/pause_menu.tscn").instantiate()
			add_child(pause_scene)
			hub_scene.visible = false
			get_tree().paused = true
	
	# Handle Game Over State
	if Autoload.current_lifes == 0:
		Autoload.save_scene()
		get_tree().call_deferred("change_scene_to_file", "res://scenes/game_over_menu.tscn")
	
	# Handle Countdown Timer Logic
	if Autoload.current_level >= 2 and timer_active:
		time_left -= delta
		if hub_scene:
			hub_scene.update_time_bar(time_left, time_limit)
		if time_left <= 0:
			timer_active = false
			time_exhausted()

# --- FILE LOADING & UI SETUP ---
# Loads message resources from the level-specific folder
func load_messages_from_folder():
	message_list.clear()
	var folder_path = "res://data/messages/level_" + str(Autoload.current_level) + "/"
	var dir = DirAccess.open(folder_path)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				var clean_name = file_name.replace(".remap", "")
				if clean_name.ends_with(".tres"):
					var res = load(folder_path + clean_name)
					if res:
						message_list.append(res)
			file_name = dir.get_next()
		dir.list_dir_end()
		message_list.shuffle()
	else:
		push_error("Could not open folder: " + folder_path)

# Updates UI labels with the current message data
func display_message():
	reset_timer()
	
	var msg = message_list[current_index]
	title_label.text = msg.title
	description_label.text = msg.description
	date_label.text = msg.date
	tip_label.text = msg.educational_tip

# --- TIMER MANAGEMENT ---
func time_exhausted():
	Autoload.remove_points(REMOVE_POINTS)
	Autoload.remove_lifes(1)
	incorrect_sound.play()
	window(false)

func reset_timer():
	time_limit = Autoload.get_time_for_level()
	time_left = time_limit
	
	if Autoload.current_level >= 2:
		timer_active = true
		if hub_scene:
			hub_scene.set_time_bar_visible(true)
			hub_scene.update_time_bar(time_left, time_limit)
	else:
		timer_active = false
		if hub_scene:
			hub_scene.set_time_bar_visible(false)

# --- GAMEPLAY LOGIC ---
# Validates player choice against the message's "is_phishing" property
func validate_choice(user_said_phishing: bool):
	timer_active = false
	
	var current_msg = message_list[current_index]
	var success = (user_said_phishing == current_msg.is_phishing)
	
	if success:
		Autoload.add_points(PUT_POINTS)
		Autoload.register_solved()
		correct_sound.play()
		window(true)
	else:
		Autoload.remove_points(REMOVE_POINTS)
		Autoload.remove_lifes(1)
		incorrect_sound.play()
		window(false)

# --- UI FEEDBACK & SIGNALS ---
# Manages the visibility and content of the result window
func window(is_correct: bool):
	solution.visible = true
	%TrustButton.disabled = true
	%ReportButton.disabled = true
	
	if is_correct:
		title_solution.text = "Correct!"
		title_solution.modulate = Color.GREEN
	else:
		title_solution.text = "Incorrect!"
		title_solution.modulate = Color.RED

func _on_trust_button_pressed():
	validate_choice(false)

func _on_report_button_pressed():
	validate_choice(true)

func _on_close_button_pressed():
	solution.visible = false
	%TrustButton.disabled = false
	%ReportButton.disabled = false
	
	current_index += 1
	if current_index < message_list.size():
		display_message()
