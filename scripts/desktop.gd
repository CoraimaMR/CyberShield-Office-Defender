extends Node2D

@onready var window = $Ventana
@onready var label = $Label
@onready var robot = $Robot
@onready var icon_btn = $CyberShieldButton 
@onready var database_btn = $DatabaseButton 
@onready var smishing_btn = $SmishingButton

const TEX_WAVE = preload("res://assets/robot/robot.png") 
const TEX_CROSSED = preload("res://assets/robot/robot-cruzado.png")
const TEX_POINT = preload("res://assets/Robot/robot-senala.png")
const MOUSE_CLICK = preload("res://assets/background/puntero-click.png")

var step = 0
var pos_inicial_robot : Vector2 
var pos_inicial_label_y : float 
<<<<<<< Updated upstream
=======
var leaderboard_scene = preload("res://scenes/LeaderBoard.tscn")

var tamano_iconos_pequenos = Vector2(0.15, 0.15)
>>>>>>> Stashed changes

func _ready():
	pos_inicial_robot = robot.position
	pos_inicial_label_y = label.position.y
	
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.position.y = pos_inicial_label_y - 20
	
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
	
<<<<<<< Updated upstream
<<<<<<< Updated upstream
	# --- COMPROBAR SI EL TUTORIAL YA SE HA COMPLETADO ---
	if Autoload.tutorial_done:
		step = 10 # Estado final sin robot
	else:
		step = 0  # Empezar tutorial desde el principio
=======
	if Autoload.tutorial_done:
		step = 10
	else:
		step = 0
>>>>>>> Stashed changes
=======
	if Autoload.tutorial_done:
		step = 10
	else:
		step = 0
>>>>>>> Stashed changes
		
	update_tutorial_state()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		if step < 8:
			step += 1
			update_tutorial_state()

func update_tutorial_state():
<<<<<<< Updated upstream
<<<<<<< Updated upstream
	# Por defecto mostramos al robot (se ocultará en el step 10)
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
	robot.show()
	robot.scale = Vector2(1, 1)
	robot.position = pos_inicial_robot
	robot.flip_h = false 
	label.position.y = pos_inicial_label_y - 20
	
	var pos_robot_apunta = Vector2(pos_inicial_robot.x - 280, pos_inicial_robot.y - 25)
	var pos_1 = pos_robot_apunta + Vector2(-380, -350)
	
	var separacion_horizontal = 180
	var elevacion_smishing = -200
	var elevacion_database = -180
	var pos_2 = pos_1 + Vector2(0, elevacion_smishing)
	var pos_3 = pos_1 + Vector2(separacion_horizontal, elevacion_database)
	
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
			robot.position = pos_robot_apunta
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
			# Ajustado un poco más a la derecha que antes
			robot.position = pos_robot_apunta + Vector2(-200, 0)
			window.hide()
			label.hide()
			if icon_btn:
				icon_btn.show()
<<<<<<< Updated upstream
<<<<<<< Updated upstream
				icon_btn.position = punta_dedo_izq + Vector2(0, -60)
			
			var punta_dedo_der = robot.position + Vector2(10, -290)
			
			if info_btn:
				info_btn.show()
				info_btn.scale = Vector2(0.25, 0.25)
				info_btn.position = punta_dedo_der + Vector2(0, -60)
				
			# --- GUARDAMOS QUE EL TUTORIAL SE HA COMPLETADO ---
=======
=======
>>>>>>> Stashed changes
				icon_btn.position = pos_1
			if smishing_btn:
				smishing_btn.show()
				smishing_btn.scale = tamano_iconos_pequenos
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
			robot.position = pos_robot_apunta + Vector2(-100, 0)
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
				database_btn.scale = tamano_iconos_pequenos
				database_btn.position = pos_3
<<<<<<< Updated upstream
>>>>>>> Stashed changes
			Autoload.tutorial_done = true
		10:
<<<<<<< Updated upstream
			# --- ESTADO CUANDO VOLVEMOS DE OTRA ESCENA ---
			robot.hide()   # Ocultamos el robot
			window.hide()  # Ocultamos el diálogo
			label.hide()   # Ocultamos el texto
			
			# Calculamos internamente dónde estaba el robot para poner los botones en el mismo sitio
			robot.position.x = pos_inicial_robot.x - 280 
			robot.position.y = pos_inicial_robot.y - 25 
			
			if icon_btn:
				icon_btn.show()
				icon_btn.scale = Vector2(0.4, 0.4)
				var punta_dedo_izq = robot.position + Vector2(-380, -290)
				icon_btn.position = punta_dedo_izq + Vector2(0, -60)
			
			if info_btn:
				info_btn.show()
				info_btn.scale = Vector2(0.25, 0.25)
				var punta_dedo_der = robot.position + Vector2(10, -290)
				info_btn.position = punta_dedo_der + Vector2(0, -60)
=======
			robot.hide()
			window.hide()
			label.hide()
			if icon_btn:
				icon_btn.show()
				icon_btn.scale = Vector2(0.4, 0.4)
=======
			Autoload.tutorial_done = true
		10:
			robot.hide()
			window.hide()
			label.hide()
			if icon_btn:
				icon_btn.show()
				icon_btn.scale = Vector2(0.4, 0.4)
>>>>>>> Stashed changes
				icon_btn.position = pos_1
			if smishing_btn:
				smishing_btn.show()
				smishing_btn.scale = tamano_iconos_pequenos
				smishing_btn.position = pos_2
			if database_btn:
				database_btn.show()
				database_btn.scale = tamano_iconos_pequenos
				database_btn.position = pos_3
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes

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
<<<<<<< Updated upstream
=======

func _on_smishing_btn_pressed():
	Input.set_custom_mouse_cursor(null)
	get_tree().change_scene_to_file("res://scenes/messages_level.tscn") 

func _on_smishing_btn_pressed():
	Input.set_custom_mouse_cursor(null)
	get_tree().change_scene_to_file("res://scenes/messages_level.tscn") 

func _on_icon_ranking_pressed() -> void:
	ScoreManager.last_player_name = ""
	var leaderboard = leaderboard_scene.instantiate()
	add_child(leaderboard)
>>>>>>> Stashed changes
