extends Control # EMAIL LEVEL

# --- CONSTANTS ---
var PUT_POINTS = 5
var REMOVE_POINTS = 10

# --- DATA & STATE ---
@export var email_list: Array[Resource] = [] # Holds EmailResource files (.tres)
var current_index: int = 0

# --- UI NODES: EMAIL CONTENT ---
@onready var sender_label = %SenderLabel
@onready var subject_label = %SubjectLabel
@onready var body_label = %BodyLabel
@onready var mail_list_container = %MailList

# --- UI NODES: POPUP & FEEDBACK ---
@onready var popup_window = $"popup window"
@onready var tip_label = $"popup window/description"
@onready var correct_label = $"popup window/text correct"
@onready var incorrect_label = $"popup window/text incorrect"
@onready var incorrect_sound = $incorrect
@onready var correct_sound = $correct

# --- NODES: EXTERNAL ---
@onready var hub_scene = %hub

# --- TIMER SETTINGS ---
var time_limit: float = 10.0      
var time_left: float = 10.0       
var timer_active: bool = false    

# --- INITIALIZATION ---
func _ready():
	Autoload.save_scene()
	load_emails_from_folder()
	
	popup_window.visible = false
	setup_mail_list()
	
	if email_list.size() > 0:
		display_email()
	else:
		body_label.text = "Error: No emails found in the list."

# --- MAIN LOOP ---
func _process(delta: float) -> void:
	# Handle Pause Menu trigger
	if Input.is_action_just_pressed("ui_cancel"):
		if not get_tree().paused:
			var pause_scene = load("res://scenes/pause_menu.tscn").instantiate()
			add_child(pause_scene)
			hub_scene.visible = false
			get_tree().paused = true
	
	# Check for Game Over state
	if Autoload.current_lifes == 0:
		Autoload.save_scene() 
		get_tree().call_deferred("change_scene_to_file", "res://scenes/game_over_menu.tscn")
	
	# Update Timer Bar for Level 2 and above
	if Autoload.current_level >= 2 and timer_active:
		time_left -= delta
		
		if hub_scene:
			hub_scene.update_time_bar(time_left, time_limit)
		
		if time_left <= 0:
			timer_active = false 
			time_exhausted()

# --- FILE LOADING & UI SETUP ---
# Dynamically loads emails based on the current level folder
func load_emails_from_folder():
	email_list.clear() 
	var folder_path = "res://data/emails/level_" + str(Autoload.current_level) + "/"
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
						email_list.append(res)
			file_name = dir.get_next()
		dir.list_dir_end()
		email_list.shuffle()
	else:
		push_error("Could not open folder: " + folder_path)

# Clears and rebuilds the sidebar email list
func setup_mail_list():
	for child in mail_list_container.get_children():
		child.queue_free()
	
	for i in range(email_list.size()):
		var label = Label.new()
		if "subject" in email_list[i]:
			label.text = "📩 " + email_list[i].subject
		else:
			label.text = "📩 Email " + str(i)
			
		label.name = "EmailItem_" + str(i)
		label.add_theme_constant_override("margin_left", 10)
		mail_list_container.add_child(label)

# Updates the main view with the selected email's data
func display_email():
	reset_timer()
	
	var mail = email_list[current_index]
	sender_label.text = "From: " + mail.sender_name + " <" + mail.sender_email + ">"
	subject_label.text = "Subject: " + mail.subject
	tip_label.text = mail.educational_tip
	body_label.text = mail.body_text

# --- TIMER LOGIC ---
func time_exhausted():
	update_list_status(false)
	Autoload.remove_points(REMOVE_POINTS)
	Autoload.remove_lifes(1)
	incorrect_sound.play()
	window(false)

func reset_timer():
	# Retrieves dynamic time limits from the Autoload script
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

# --- GAMEPLAY VALIDATION ---
func validate_choice(user_said_phishing: bool):
	timer_active = false 
	
	var current_mail = email_list[current_index]
	var success = (user_said_phishing == current_mail.is_phishing)
	
	update_list_status(success)
	
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
# Controls the feedback popup window
func window(is_correct: bool):
	popup_window.visible = true
	%TrustButton.disabled = true
	%ReportButton.disabled = true
	
	correct_label.visible = is_correct
	incorrect_label.visible = not is_correct

# Updates the sidebar indicators (Checkmarks/Crosses)
func update_list_status(is_correct: bool):
	var label = %MailList.get_child(current_index)
	if label:
		if is_correct:
			label.text = "✅ " + email_list[current_index].subject
			label.add_theme_color_override("font_color", Color.GREEN)
		else:
			label.text = "❌ " + email_list[current_index].subject
			label.add_theme_color_override("font_color", Color.RED)

func _on_trust_button_pressed():
	validate_choice(false) 

func _on_report_button_pressed():
	validate_choice(true) 

func _on_close_button_pressed() -> void:
	popup_window.visible = false
	%TrustButton.disabled = false
	%ReportButton.disabled = false
	
	current_index += 1
	if current_index < email_list.size():
		display_email()
