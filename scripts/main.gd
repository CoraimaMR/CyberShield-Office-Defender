extends Control

# This array will hold your EmailResource files (.tres)
# You can drag and drop them into the Inspector
@export var email_list: Array[EmailResource] = []

var current_index: int = 0
var score: int = 0

# Unique Name access using the '%' symbol
@onready var score_label = %ScoreLabel
@onready var sender_label = %SenderLabel
@onready var subject_label = %SubjectLabel
@onready var body_label = %BodyLabel

func _ready():
	# Update the UI with the first email if the list is not empty
	if email_list.size() > 0:
		display_email()
	else:
		body_label.text = "Error: No emails found in the list."

func display_email():
	var mail = email_list[current_index]
	sender_label.text = "From: " + mail.sender_name + " <" + mail.sender_email + ">"
	subject_label.text = "Subject: " + mail.subject
	
	# We use 'text' for RichTextLabel, or 'set_bbcode' in older versions
	body_label.text = mail.body_text
	score_label.text = "Score: " + str(score)

func _on_trust_button_pressed():
	validate_choice(false) # User thinks it's SAFE

func _on_report_button_pressed():
	validate_choice(true) # User thinks it's PHISHING

func validate_choice(user_said_phishing: bool):
	var current_mail = email_list[current_index]
	
	if user_said_phishing == current_mail.is_phishing:
		score += 10
		print("Correct! +10 points")
	else:
		score -= 5
		print("Wrong! -5 points")
	
	# Move to the next email
	current_index += 1
	
	if current_index < email_list.size():
		display_email()
	else:
		finish_game()

func finish_game():
	sender_label.text = ""
	subject_label.text = "Jornada terminada"
	body_label.text = "[center][b]Final Score: " + str(score) + "[/b][/center]\n\nThanks for playing and staying safe!"
	# Disable buttons at the end
	%TrustButton.disabled = true
	%ReportButton.disabled = true
