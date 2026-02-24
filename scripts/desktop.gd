extends Node2D

# --- ONREADY NODES ---
@onready var window = $Window
@onready var label = $Label
@onready var robot = $Robot
@onready var icon_btn = $CyberShieldButton 
@onready var info_btn = $InfoButton 

# --- ASSETS & RESOURCES ---
const TEX_WAVE = preload("res://assets/robot/robot.png") 
const TEX_CROSSED = preload("res://assets/robot/robot-cruzado.png")
const TEX_POINT = preload("res://assets/Robot/robot-senala.png")
const MOUSE_CLICK = preload("res://assets/background/puntero-click.png")

# --- STATE & CONFIGURATION ---
var step = 0
var pos_inicial_robot : Vector2 
var pos_inicial_label_y : float 
var leaderboard_scene = preload("res://scenes/LeaderBoard.tscn") # hall of fame

# --- INITIALIZATION ---
func _ready():
	# Store initial positions for reference
	pos_inicial_robot = robot.position
	pos_inicial_label_y = label.position.y
	
	# Configure label appearance
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.position.y = pos_inicial_label_y - 20
	
	# Initialize CyberShield button signals and state
	if icon_btn:
		icon_btn.pivot_offset = icon_btn.size / 2
		icon_btn.hide()
		icon_btn.mouse_entered.connect(_on_mouse_entered_btn)
		icon_btn.mouse_exited.connect(_on_mouse_exited_btn)
		if not icon_btn.pressed.is_connected(_on_cyber_shield_btn_pressed):
			icon_btn.pressed.connect(_on_cyber_shield_btn_pressed)
			
	# Initialize Info button signals and state
	if info_btn:
		info_btn.pivot_offset = info_btn.size / 2
		info_btn.hide()
		info_btn.mouse_entered.connect(_on_mouse_entered_btn)
		info_btn.mouse_exited.connect(_on_mouse_exited_btn)
		if not info_btn.pressed.is_connected(_on_info_btn_pressed):
			info_btn.pressed.connect(_on_info_btn_pressed)
	
	# Check tutorial persistence
	if Autoload.tutorial_done:
		step = 10 # Skip to final layout
	else:
		step = 0  # Start from beginning
		
	update_tutorial_state()

# --- INPUT HANDLING ---
func _unhandled_input(event):
	# Advance tutorial on left mouse click
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		if step < 6: 
			step += 1
			update_tutorial_state()

# --- TUTORIAL LOGIC ---
func update_tutorial_state():
	# Default resets for each step
	robot.show()
	robot.scale = Vector2(1, 1)
	robot.position = pos_inicial_robot
	robot.flip_h = false 
	label.position.y = pos_inicial_label_y - 20
	
	match step:
		0: # Introduction
			robot.texture = TEX_WAVE
			label.text = "Hi! My name is Roby."
			window.show()
			label.show()
			if icon_btn: icon_btn.hide()
			if info_btn: info_btn.hide()
		1: # Context
			robot.texture = TEX_CROSSED
			label.text = "I'm going to help you understand what 'Phishing' is."
		2: # Definition
			label.text = "It is a deception where hackers pretend to be real companies to steal your data."
		3: # Call to action
			robot.texture = TEX_CROSSED
			label.text = "If you want to check that you have understood Phishing, you can enter CyberShield."
			window.show()
			label.show()
		4: # Highlight CyberShield button
			robot.texture = TEX_POINT
			robot.scale = Vector2(0.22, 0.22)
			robot.position.x = pos_inicial_robot.x - 280
			robot.position.y = pos_inicial_robot.y - 25 
			window.hide()
			label.hide()
			
			var punta_dedo_izq = robot.position + Vector2(-380, -290)
			if icon_btn:
				icon_btn.show()
				icon_btn.scale = Vector2(0.4, 0.4)
				icon_btn.position = punta_dedo_izq + Vector2(0, -60)
		5: # Database info
			robot.texture = TEX_CROSSED
			window.show()
			label.show()
			label.text = "You can also check our database for other existing malware."
			if icon_btn:
				icon_btn.hide()
		6: # Show both interaction buttons
			robot.texture = TEX_POINT
			robot.scale = Vector2(0.22, 0.22)
			robot.flip_h = true 
			robot.position.x = pos_inicial_robot.x - 280 
			robot.position.y = pos_inicial_robot.y - 25 
			window.hide()
			label.hide()
			
			var punta_dedo_izq = robot.position + Vector2(-380, -290)
			if icon_btn:
				icon_btn.show()
				icon_btn.position = punta_dedo_izq + Vector2(0, -60)
			
			var punta_dedo_der = robot.position + Vector2(10, -290)
			if info_btn:
				info_btn.show()
				info_btn.scale = Vector2(0.7, 0.7)
				info_btn.position = punta_dedo_der + Vector2(0, -60)
				
			Autoload.tutorial_done = true
		10: # Persistent UI state (Tutorial skipped/finished)
			robot.hide()
			window.hide()
			label.hide()
			
			robot.position.x = pos_inicial_robot.x - 280 
			robot.position.y = pos_inicial_robot.y - 25 
			
			if icon_btn:
				icon_btn.show()
				icon_btn.scale = Vector2(0.4, 0.4)
				var punta_dedo_izq = robot.position + Vector2(-380, -290)
				icon_btn.position = punta_dedo_izq + Vector2(0, -60)
			
			if info_btn:
				info_btn.show()
				info_btn.scale = Vector2(0.7, 0.7)
				var punta_dedo_der = robot.position + Vector2(10, -290)
				info_btn.position = punta_dedo_der + Vector2(0, -60)

# --- UI INTERACTION CALLBACKS ---
func _on_mouse_entered_btn():
	# Change to custom click cursor
	Input.set_custom_mouse_cursor(MOUSE_CLICK, Input.CURSOR_ARROW, Vector2(0, 0))

func _on_mouse_exited_btn():
	# Reset cursor to default
	Input.set_custom_mouse_cursor(null)

func _on_cyber_shield_btn_pressed():
	Input.set_custom_mouse_cursor(null)
	get_tree().change_scene_to_file("res://scenes/email_level.tscn")

func _on_info_btn_pressed():
	Input.set_custom_mouse_cursor(null)
	get_tree().change_scene_to_file("res://scenes/malware_gallery.tscn")

func _on_icon_ranking_pressed() -> void:
	# Show Leaderboard overlay
	ScoreManager.last_player_name = ""
	var leaderboard = leaderboard_scene.instantiate()
	add_child(leaderboard)
