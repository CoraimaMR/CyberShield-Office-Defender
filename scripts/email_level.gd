extends Control # EMAIL LEVEL

# This array will hold your EmailResource files (.tres)
# You can drag and drop them into the Inspector
@export var email_list: Array[EmailResource] = []

var current_index: int = 0

# Unique Name access using the '%' symbol
@onready var sender_label = %SenderLabel
@onready var subject_label = %SubjectLabel
@onready var body_label = %BodyLabel
@onready var mail_list_container = %MailList

@onready var incorrect_sound = $incorrect
@onready var correct_sound = $correct
@onready var tip_label = $"popup window/description"
@onready var popup_window = $"popup window"
@onready var correct_label = $"popup window/text correct"
@onready var incorrect_label = $"popup window/text incorrect"

@onready var time_bar = %TimeBar # timebar
var time_limit: float = 10.0      # total time
var time_left: float = 10.0       # left time
var timer_active: bool = false	# flag

func _ready():
	load_emails_from_folder()
	
	popup_window.visible = false
	setup_mail_list()
	# Update the UI with the first email if the list is not empty
	if email_list.size() > 0:
		display_email()
	else:
		body_label.text = "Error: No emails found in the list."

func _process(_delta: float) -> void:
	# PAUSE MENU
	if Input.is_action_just_pressed("ui_cancel"):
		Autoload.save_scene() # Save scene
		get_tree().call_deferred("change_scene_to_file", "res://scenes/pause_menu.tscn") # Go to the pause menu
	
	# GAME OVER MENU
	if Autoload.current_lifes == 0:
		Autoload.save_scene() # Save scene
		get_tree().call_deferred("change_scene_to_file", "res://scenes/game_over_menu.tscn") # Go to the game over menu
	
	if Autoload.current_level >= 2:
		time_left -= delta
		time_bar.value = (time_left * 100) / time_limit
		
		if time_left <= 0:
			timer_active = false
			time_exhausted()
	
func time_exhausted():
	Autoload.remove_lifes(1)
	incorrect_sound.play()
	# next email
	current_index += 1
	if current_index < email_list.size():
		display_email()
	else:
		Autoload.save_scene()
		get_tree().call_deferred("change_scene_to_file", "res://scenes/win_menu.tscn")

func reset_timer():
	time_left = time_limit # reset time
	if Autoload.current_level >= 2:
		timer_active = true
		time_bar.visible = true
	else:
		timer_active = false
		time_bar.visible = false

func load_emails_from_folder():
	email_list.clear() # clear in case we are coming from another level
	var folder_path = "res://data/emails/level_" + str(Autoload.current_level) + "/"
	
	var dir = DirAccess.open(folder_path)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			# filter to load only resource files (.tres)
			if file_name.ends_with(".tres"):
				var full_path = folder_path + file_name
				var email_res = load(full_path)
				if email_res is EmailResource:
					email_list.append(email_res)
			file_name = dir.get_next()
		
		dir.list_dir_end()
		
		# shuffle the list for a random order
		email_list.shuffle()
	else:
		print("Critical error: Could not access the folder: ", folder_path)

func setup_mail_list():
	# clean up any leftover test nodes
	for child in mail_list_container.get_children():
		child.queue_free()
	
	# create a Label in the blue column for each email in the array
	for i in range(email_list.size()):
		var label = Label.new()
		label.text = "📩 " + email_list[i].subject
		label.name = "EmailItem_" + str(i)
		# add some padding so it's not touching the edge
		label.add_theme_constant_override("margin_left", 10)
		mail_list_container.add_child(label)

func display_email():
	var mail = email_list[current_index]
	sender_label.text = "From: " + mail.sender_name + " <" + mail.sender_email + ">"
	subject_label.text = "Subject: " + mail.subject
	tip_label.text = mail.educational_tip
	
	# We use 'text' for RichTextLabel, or 'set_bbcode' in older versions
	body_label.text = mail.body_text

func _on_trust_button_pressed():
	validate_choice(false) # User thinks it's SAFE

func _on_report_button_pressed():
	validate_choice(true) # User thinks it's PHISHING

func validate_choice(user_said_phishing: bool):
	var current_mail = email_list[current_index]
	var success = (user_said_phishing == current_mail.is_phishing)
	
	update_list_status(success)
	# update the icon in the list before moving to the next one
	if success:
		print("Correct! +5 points")
		Autoload.add_points(5)
		correct_sound.play()
		window(true)
	else:
		print("Wrong! -10 points")
		Autoload.remove_points(10)
		Autoload.remove_lifes(1)
		incorrect_sound.play()
		window(false)

func window(is_correct: bool):
	popup_window.visible = true
	%TrustButton.disabled = true
	%ReportButton.disabled = true
	if is_correct:
		correct_label.visible = true
		incorrect_label.visible = false
	else:
		incorrect_label.visible = true
		correct_label.visible = false

func _on_close_button_pressed() -> void:
	popup_window.visible = false
	%TrustButton.disabled = false
	%ReportButton.disabled = false
	# Move to the next email
	current_index += 1
	if current_index < email_list.size():
			display_email()
	else:
		# WIN MENU
		Autoload.save_scene() # Save scene
		get_tree().call_deferred("change_scene_to_file", "res://scenes/win_menu.tscn") # Go to the win menu

func update_list_status(is_correct: bool):
	# get the Label node located inside MailList at the current index/position
	var label = %MailList.get_child(current_index)
	
	if is_correct:
		label.text = "✅ " + email_list[current_index].subject
		label.add_theme_color_override("font_color", Color.GREEN)
	else:
		label.text = "❌ " + email_list[current_index].subject
		label.add_theme_color_override("font_color", Color.RED)
