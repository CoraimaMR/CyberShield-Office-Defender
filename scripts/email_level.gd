extends Control

# This array will hold your EmailResource files (.tres)
# You can drag and drop them into the Inspector
@export var email_list: Array[EmailResource] = []

var current_index: int = 0

# Unique Name access using the '%' symbol
@onready var sender_label = %SenderLabel
@onready var subject_label = %SubjectLabel
@onready var body_label = %BodyLabel
@onready var incorrect_sound = $incorrect
@onready var correct_sound = $correct

func _ready():
	# Update the UI with the first email if the list is not empty
	if email_list.size() > 0:
		display_email()
	else:
		body_label.text = "Error: No emails found in the list."

func _process(_delta: float) -> void:
	if Autoload.current_lifes == 0: 
		get_tree().call_deferred("change_scene_to_file", "res://scenes/game_over_menu.tscn") # Go to the game over menu

func display_email():
	var mail = email_list[current_index]
	sender_label.text = "From: " + mail.sender_name + " <" + mail.sender_email + ">"
	subject_label.text = "Subject: " + mail.subject
	
	# We use 'text' for RichTextLabel, or 'set_bbcode' in older versions
	body_label.text = mail.body_text

func _on_trust_button_pressed():
	validate_choice(false) # User thinks it's SAFE

func _on_report_button_pressed():
	validate_choice(true) # User thinks it's PHISHING

func validate_choice(user_said_phishing: bool):
	var current_mail = email_list[current_index]
	
	if user_said_phishing == current_mail.is_phishing:
		print("Correct! +5 points")
		Autoload.add_points(5)
		correct_sound.play()
	else:
		print("Wrong! -10 points")
		Autoload.remove_points(10)
		Autoload.remove_lifes(1)
		incorrect_sound.play()
	
	# Move to the next email
	current_index += 1
	
	if current_index < email_list.size():
		display_email()
	else:
		get_tree().call_deferred("change_scene_to_file", "res://scenes/win_menu.tscn") # Go to the win menu
