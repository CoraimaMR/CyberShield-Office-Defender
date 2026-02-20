extends Node2D

@onready var window = $Ventana
@onready var label = $Label
@onready var robot = $Robot
@onready var icon_btn = $CyberShieldButton 

const TEX_WAVE = preload("res://assets/robot/robot.png") 
const TEX_CROSSED = preload("res://assets/robot/robot-cruzado.png")
const TEX_POINT = preload("res://assets/Robot/robot-senala.png")
const MOUSE_CLICK = preload("res://assets/background/puntero-click.png")

var step = 0
var pos_inicial_robot : Vector2 
var pos_inicial_label_y : float 

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
<<<<<<< Updated upstream
=======
			
	if info_btn:
		info_btn.pivot_offset = info_btn.size / 2
		info_btn.hide()
		info_btn.mouse_entered.connect(_on_mouse_entered_btn)
		info_btn.mouse_exited.connect(_on_mouse_exited_btn)
		if not info_btn.pressed.is_connected(_on_info_btn_pressed):
			info_btn.pressed.connect(_on_info_btn_pressed)
<<<<<<< Updated upstream
>>>>>>> Stashed changes
	
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
		
	update_tutorial_state()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		if step < 6: 
			step += 1
			update_tutorial_state()

func update_tutorial_state():
<<<<<<< Updated upstream
	# Por defecto mostramos al robot (se ocultará en el step 10)
=======
>>>>>>> Stashed changes
	robot.show()
	robot.scale = Vector2(1, 1)
	robot.position = pos_inicial_robot
	robot.flip_h = false 
	label.position.y = pos_inicial_label_y - 20
	
	match step:
		0:
			robot.texture = TEX_WAVE
			label.text = "¡Hola! Me llamo Roby."
			window.show()
			label.show()
			if icon_btn: icon_btn.hide()
		1:
			robot.texture = TEX_CROSSED
<<<<<<< Updated upstream
<<<<<<< Updated upstream
			label.text = "Te voy a ayudar a entender qué es el 'Phishing'."
=======
			label.text = "I'm going to help you understand what 'Phishing' is."
>>>>>>> Stashed changes
=======
			label.text = "I'm going to help you understand what 'Phishing' is."
>>>>>>> Stashed changes
		2:
			label.text = "Es un engaño donde los hackers fingen ser empresas reales para robar tus datos."
		3:
			robot.texture = TEX_CROSSED
<<<<<<< Updated upstream
<<<<<<< Updated upstream
			label.text = "Para comprobar que lo has entendido, vamos a entrar en CyberShield."
=======
			label.text = "If you want to check that you have understood Phishing, you can enter CyberShield."
			window.show()
			label.show()
>>>>>>> Stashed changes
=======
			label.text = "If you want to check that you have understood Phishing, you can enter CyberShield."
			window.show()
			label.show()
>>>>>>> Stashed changes
		4:
			robot.texture = TEX_POINT
			robot.scale = Vector2(0.22, 0.22)
			
			robot.position.x = pos_inicial_robot.x - 250
			robot.position.y = pos_inicial_robot.y - 25 
			
			window.hide()
			label.hide()
			
<<<<<<< Updated upstream
<<<<<<< Updated upstream
			if icon_btn:
				icon_btn.show()
				icon_btn.scale = Vector2(0.4, 0.4)
				
				var offset_dedo = Vector2(-380, -290)
				icon_btn.position = robot.position + offset_dedo

=======
=======
>>>>>>> Stashed changes
			var punta_dedo_izq = robot.position + Vector2(-380, -290)
			
			if icon_btn:
				icon_btn.show()
				icon_btn.scale = Vector2(0.4, 0.4)
				icon_btn.position = punta_dedo_izq + Vector2(0, -60)
				
		5:
			robot.texture = TEX_CROSSED
			window.show()
			label.show()
			label.text = "You can also check our database for other existing malware."
			
			if icon_btn:
				icon_btn.hide()
			
		6:
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
				info_btn.scale = Vector2(0.25, 0.25)
				info_btn.position = punta_dedo_der + Vector2(0, -60)
				
<<<<<<< Updated upstream
			# --- GUARDAMOS QUE EL TUTORIAL SE HA COMPLETADO ---
			Autoload.tutorial_done = true
			
		10:
			# --- ESTADO CUANDO VOLVEMOS DE OTRA ESCENA ---
			robot.hide()   # Ocultamos el robot
			window.hide()  # Ocultamos el diálogo
			label.hide()   # Ocultamos el texto
			
			# Calculamos internamente dónde estaba el robot para poner los botones en el mismo sitio
=======
			Autoload.tutorial_done = true
			
		10:
			robot.hide()
			window.hide()
			label.hide()
			
>>>>>>> Stashed changes
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
