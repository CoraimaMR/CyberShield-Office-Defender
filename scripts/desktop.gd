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
	
	update_tutorial_state()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		if step < 4:
			step += 1
			update_tutorial_state()

func update_tutorial_state():
	robot.scale = Vector2(1, 1)
	robot.position = pos_inicial_robot
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
			label.text = "Te voy a ayudar a entender qué es el 'Phishing'."
		2:
			label.text = "Es un engaño donde los hackers fingen ser empresas reales para robar tus datos."
		3:
			robot.texture = TEX_CROSSED
			label.text = "Para comprobar que lo has entendido, vamos a entrar en CyberShield."
		4:
			robot.texture = TEX_POINT
			robot.scale = Vector2(0.22, 0.22)
			
			robot.position.x = pos_inicial_robot.x - 250
			robot.position.y = pos_inicial_robot.y - 25 
			
			window.hide()
			label.hide()
			
			if icon_btn:
				icon_btn.show()
				icon_btn.scale = Vector2(0.4, 0.4)
				
				var offset_dedo = Vector2(-380, -290)
				icon_btn.position = robot.position + offset_dedo


func _on_mouse_entered_btn():
	Input.set_custom_mouse_cursor(MOUSE_CLICK, Input.CURSOR_ARROW, Vector2(0, 0))

func _on_mouse_exited_btn():
	Input.set_custom_mouse_cursor(null)

func _on_cyber_shield_btn_pressed():
	Input.set_custom_mouse_cursor(null)
	get_tree().change_scene_to_file("res://scenes/email_level.tscn")
