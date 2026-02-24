extends Node2D # DESKTOP

@onready var window = $Window
@onready var label = $Label
@onready var robot = $Robot
@onready var icon_btn = $CyberShieldButton 
@onready var database_btn = $DatabaseButton 
@onready var smishing_btn = $SmishingButton

# --- ASSETS ---
const TEX_WAVE = preload("res://assets/robot/robot.png") 
const TEX_CROSSED = preload("res://assets/robot/robot-cruzado.png")
const TEX_POINT = preload("res://assets/Robot/robot-senala.png")
const MOUSE_CLICK = preload("res://assets/background/puntero-click.png")

# --- STATE & SETTINGS ---
var step = 0
var robot_initial_pos : Vector2 
var label_initial_pos_y : float 
var leaderboard_scene = preload("res://scenes/LeaderBoard.tscn")
var small_icons_size = Vector2(0.15, 0.15)

func _ready():
	# Store initial positions for animations
	robot_initial_pos = robot.position
	label_initial_pos_y = label.position.y
	
	# Label formatting
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.position.y = label_initial_pos_y - 20
	
	# Setup button signals and hover effects
	if icon_btn:
		icon_btn.pivot_offset = icon_btn.size / 2
		icon_btn.hide()
		icon_btn.mouse_entered.connect(_on_mouse_entered_btn)
		icon_btn.mouse_exited.connect(_on_mouse_exited_btn)
		if not icon_btn.pressed.is_connected(_on_cyber_shield_btn_pressed):
			icon_btn.pressed.connect(_on_cyber_shield_btn_pressed)
			
	if database_btn:
		database_btn.pivot_offset = database_btn.size / 2
		database_btn.hide()
		database_btn.mouse_entered.connect(_on_mouse_entered_btn)
		database_btn.mouse_exited.connect(_on_mouse_exited_btn)
		if not database_btn.pressed.is_connected(_on_database_btn_pressed):
			database_btn.pressed.connect(_on_database_btn_pressed)

	if smishing_btn:
		smishing_btn.pivot_offset = smishing_btn.size / 2
		smishing_btn.hide()
		smishing_btn.mouse_entered.connect(_on_mouse_entered_btn)
		smishing_btn.mouse_exited.connect(_on_mouse_exited_btn)
		if not smishing_btn.pressed.is_connected(_on_smishing_btn_pressed):
			smishing_btn.pressed.connect(_on_smishing_btn_pressed)
	
	# Skip tutorial if already done
	if Autoload.tutorial_done:
		step = 10
	else:
		step = 0
		
	update_tutorial_state()

func _unhandled_input(event):
	# Advance tutorial on mouse click
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		if step < 8:
			step += 1
			update_tutorial_state()

func update_tutorial_state():
	# Reset robot defaults for each step
	robot.show()
	robot.scale = Vector2(1, 1)
	robot.position = robot_initial_pos
	robot.flip_h = false 
	label.position.y = label_initial_pos_y - 20
	
	# Calculate dynamic positions for pointing
	var robot_pointing_pos = Vector2(robot_initial_pos.x - 280, robot_initial_pos.y - 25)
	var pos_1 = robot_pointing_pos + Vector2(-380, -350)
	
	var horizontal_spacing = 180
	var smishing_elevation = -200
	var database_elevation = -180
	var pos_2 = pos_1 + Vector2(0, smishing_elevation)
	var pos_3 = pos_1 + Vector2(horizontal_spacing, database_elevation)
	
	match step:
		0:
			robot.texture = TEX_WAVE
			label.text = "Hi! My name is Roby."
			window.show()
			label.show()
			if icon_btn: icon_btn.hide()
			if database_btn: database_btn.hide()
			if smishing_btn: smishing_btn.hide()
		1:
			robot.texture = TEX_CROSSED
			label.text = "I'm going to help you understand what 'Phishing' is."
		2:
			label.text = "It is a deception where hackers pretend to be real companies to steal your data."
		3:
			robot.texture = TEX_CROSSED
			label.text = "If you want to check that you have understood Phishing, you can enter CyberShield."
			window.show()
			label.show()
		4:
			robot.texture = TEX_POINT
			robot.scale = Vector2(0.22, 0.22)
			robot.position = robot_pointing_pos
			window.hide()
			label.hide()
			if icon_btn:
				icon_btn.show()
				icon_btn.scale = Vector2(0.4, 0.4)
				icon_btn.position = pos_1
		5:
			robot.texture = TEX_CROSSED
			window.show()
			label.show()
			label.text = "We also cover 'Smishing', a dangerous type of phishing sent via SMS."
			if icon_btn: icon_btn.hide()
			if database_btn: database_btn.hide()
			if smishing_btn: smishing_btn.hide()
		6:
			robot.texture = TEX_POINT
			robot.scale = Vector2(0.22, 0.22)
			robot.flip_h = true
			robot.position = robot_pointing_pos + Vector2(-200, 0)
			window.hide()
			label.hide()
			if icon_btn:
				icon_btn.show()
				icon_btn.position = pos_1
			if smishing_btn:
				smishing_btn.show()
				smishing_btn.scale = small_icons_size
				smishing_btn.position = pos_2
		7:
			robot.texture = TEX_CROSSED
			robot.flip_h = false
			window.show()
			label.show()
			label.text = "You can also check our database for other existing malware."
			if icon_btn: icon_btn.hide()
			if database_btn: database_btn.hide()
			if smishing_btn: smishing_btn.hide()
		8:
			robot.texture = TEX_POINT
			robot.scale = Vector2(0.22, 0.22)
			robot.flip_h = true
			robot.position = robot_pointing_pos + Vector2(-100, 0)
			window.hide()
			label.hide()
			if icon_btn:
				icon_btn.show()
				icon_btn.position = pos_1
			if smishing_btn:
				smishing_btn.show()
				smishing_btn.position = pos_2
			if database_btn:
				database_btn.show()
				database_btn.scale = small_icons_size
				database_btn.position = pos_3
			Autoload.tutorial_done = true
		10: # Final state: Hide robot and show all buttons
			robot.hide()
			window.hide()
			label.hide()
			if icon_btn:
				icon_btn.show()
				icon_btn.scale = Vector2(0.4, 0.4)
				icon_btn.position = pos_1
			if smishing_btn:
				smishing_btn.show()
				smishing_btn.scale = small_icons_size
				smishing_btn.position = pos_2
			if database_btn:
				database_btn.show()
				database_btn.scale = small_icons_size
				database_btn.position = pos_3

# --- SIGNAL CALLBACKS ---
func _on_mouse_entered_btn():
	Input.set_custom_mouse_cursor(MOUSE_CLICK, Input.CURSOR_ARROW, Vector2(0, 0))

func _on_mouse_exited_btn():
	Input.set_custom_mouse_cursor(null)

func _on_cyber_shield_btn_pressed():
	Input.set_custom_mouse_cursor(null)
	get_tree().change_scene_to_file("res://scenes/email_level.tscn")

func _on_database_btn_pressed():
	Input.set_custom_mouse_cursor(null)
	get_tree().change_scene_to_file("res://scenes/malware_gallery.tscn")

func _on_smishing_btn_pressed():
	Input.set_custom_mouse_cursor(null)
	get_tree().change_scene_to_file("res://scenes/messages_level.tscn") 

func _on_icon_ranking_pressed() -> void:
	ScoreManager.last_player_name = ""
	var leaderboard = leaderboard_scene.instantiate()
	add_child(leaderboard)
